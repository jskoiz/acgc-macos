#include "acgc_filesystem_adapter.h"

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static int failures;

static void check_true(const char *label, int condition)
{
    if (!condition) {
        fprintf(stderr, "FAIL: %s\n", label);
        ++failures;
    }
}

static void check_status(const char *label, acgc_fs_status actual, acgc_fs_status expected)
{
    if (actual != expected) {
        fprintf(stderr, "FAIL: %s: got %s, expected %s\n", label,
                acgc_fs_status_name(actual), acgc_fs_status_name(expected));
        ++failures;
    }
}

static int mkdir_p_for_test(const char *path)
{
    char working[PATH_MAX];
    char *cursor;

    if (path == NULL || path[0] != '/' || strlen(path) >= sizeof(working)) {
        return 0;
    }
    strcpy(working, path);
    for (cursor = working + 1; ; ++cursor) {
        char original = *cursor;

        if (original != '/' && original != '\0') {
            continue;
        }
        if (original == '/') {
            *cursor = '\0';
        }
        if (mkdir(working, 0700) != 0 && errno != EEXIST) {
            return 0;
        }
        {
            struct stat info;
            if (stat(working, &info) != 0 || !S_ISDIR(info.st_mode)) {
                return 0;
            }
        }
        if (original == '\0') {
            break;
        }
        *cursor = '/';
    }
    return 1;
}

static int write_direct(const char *path, const uint8_t *bytes, size_t length)
{
    int file_descriptor;
    size_t offset = 0;

    file_descriptor = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0600);
    if (file_descriptor < 0) {
        return 0;
    }
    if (fchmod(file_descriptor, 0600) != 0) {
        (void)close(file_descriptor);
        return 0;
    }
    while (offset < length) {
        ssize_t written = write(file_descriptor, bytes + offset, length - offset);
        if (written < 0 && errno == EINTR) {
            continue;
        }
        if (written <= 0) {
            (void)close(file_descriptor);
            return 0;
        }
        offset += (size_t)written;
    }
    return close(file_descriptor) == 0;
}

static int flip_last_byte(const char *path)
{
    int file_descriptor;
    uint8_t byte;

    file_descriptor = open(path, O_RDWR);
    if (file_descriptor < 0 || lseek(file_descriptor, -1, SEEK_END) < 0 ||
        read(file_descriptor, &byte, sizeof(byte)) != (ssize_t)sizeof(byte)) {
        if (file_descriptor >= 0) {
            (void)close(file_descriptor);
        }
        return 0;
    }
    byte ^= 0x5a;
    if (lseek(file_descriptor, -1, SEEK_END) < 0 ||
        write(file_descriptor, &byte, sizeof(byte)) != (ssize_t)sizeof(byte)) {
        (void)close(file_descriptor);
        return 0;
    }
    return close(file_descriptor) == 0;
}

static int file_mode_is(const char *path, mode_t expected_mode)
{
    struct stat info;

    return stat(path, &info) == 0 && S_ISREG(info.st_mode) && (info.st_mode & 0777) == expected_mode;
}

static int directory_mode_is(const char *path, mode_t expected_mode)
{
    struct stat info;

    return stat(path, &info) == 0 && S_ISDIR(info.st_mode) && (info.st_mode & 0777) == expected_mode;
}

static int count_temporary_files(const char *directory)
{
    DIR *stream;
    struct dirent *entry;
    int count = 0;

    stream = opendir(directory);
    if (stream == NULL) {
        return -1;
    }
    while ((entry = readdir(stream)) != NULL) {
        if (strstr(entry->d_name, ".tmp.") != NULL) {
            ++count;
        }
    }
    (void)closedir(stream);
    return count;
}

static int count_iso_files(const char *directory)
{
    DIR *stream;
    struct dirent *entry;
    int count = 0;

    stream = opendir(directory);
    if (stream == NULL) {
        return -1;
    }
    while ((entry = readdir(stream)) != NULL) {
        char path[PATH_MAX];
        struct stat info;
        int written;

        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }
        written = snprintf(path, sizeof(path), "%s/%s", directory, entry->d_name);
        if (written < 0 || (size_t)written >= sizeof(path) || lstat(path, &info) != 0) {
            (void)closedir(stream);
            return -1;
        }
        if (S_ISDIR(info.st_mode)) {
            int nested = count_iso_files(path);
            if (nested < 0) {
                (void)closedir(stream);
                return -1;
            }
            count += nested;
        } else if (S_ISREG(info.st_mode) &&
                   strlen(entry->d_name) >= 4 &&
                   strcmp(entry->d_name + strlen(entry->d_name) - 4, ".iso") == 0) {
            ++count;
        }
    }
    (void)closedir(stream);
    return count;
}

static int paths_are_distinct(const acgc_fs_roots *roots)
{
    const char *resources = acgc_fs_root_path(roots, ACGC_FS_RESOURCES);
    const char *application_support = acgc_fs_root_path(roots, ACGC_FS_APPLICATION_SUPPORT);
    const char *cache = acgc_fs_root_path(roots, ACGC_FS_CACHE);
    const char *logs = acgc_fs_root_path(roots, ACGC_FS_LOGS);

    return resources != NULL && application_support != NULL && cache != NULL && logs != NULL &&
           strcmp(resources, application_support) != 0 && strcmp(resources, cache) != 0 &&
           strcmp(resources, logs) != 0 && strcmp(application_support, cache) != 0 &&
           strcmp(application_support, logs) != 0 && strcmp(cache, logs) != 0;
}

int main(int argc, char **argv)
{
    char run_template[PATH_MAX];
    char resources[PATH_MAX];
    char home[PATH_MAX];
    char path[PATH_MAX];
    char save_path[PATH_MAX];
    char temporary_path[PATH_MAX];
    char iso_path[PATH_MAX];
    char outside_iso_path[PATH_MAX];
    char *run_root;
    const char *app_support;
    const char *cache;
    const char *logs;
    acgc_fs_roots roots;
    acgc_fs_durability_report report;
    acgc_fs_status status;
    uint8_t output[128];
    size_t output_length = 0;
    const uint8_t synthetic_iso[] = "synthetic source sentinel; not a game asset\n";
    const uint8_t cache_bytes[] = {0xca, 0xfe, 0xba, 0xbe};
    const uint8_t log_bytes[] = "filesystem lane log\n";
    const uint8_t payload_a[] = {0x00, 0x01, 0x7f, 0x80, 0xfe, 0xff, 'A', 'C', 'G', 'C'};
    const uint8_t payload_b[] = "second durable opaque save payload";
    const uint8_t malformed[] = {'A', 'C', 'G', 'S', 1, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    if (argc != 2 || strlen(argv[1]) >= sizeof(run_template) - 12) {
        fprintf(stderr, "usage: %s BUILD_DIR\n", argv[0]);
        return 2;
    }
    snprintf(run_template, sizeof(run_template), "%s/run.XXXXXX", argv[1]);
    run_root = mkdtemp(run_template);
    check_true("created unique filesystem test root", run_root != NULL);
    if (run_root == NULL) {
        return 1;
    }

    snprintf(resources, sizeof(resources), "%s/Bundle.app/Contents/Resources", run_root);
    snprintf(home, sizeof(home), "%s/SandboxHome", run_root);
    check_true("created synthetic bundle resources", mkdir_p_for_test(resources));
    check_true("created synthetic sandbox home", mkdir_p_for_test(home));
    snprintf(iso_path, sizeof(iso_path), "%s/Animal Crossing (USA).iso", resources);
    check_true("created synthetic ISO sentinel", write_direct(iso_path, synthetic_iso,
                                                                sizeof(synthetic_iso) - 1));
    check_true("selected resource sentinel is read-only in fixture",
               chmod(resources, 0555) == 0);
    check_true("selected deterministic sandbox home", setenv("CFFIXED_USER_HOME", home, 1) == 0);

    status = acgc_fs_macos_roots_init(&roots, resources, "com.acgc.modernport.lane");
    check_status("resolved macOS role roots", status, ACGC_FS_OK);
    check_true("role roots are distinct", paths_are_distinct(&roots));
    status = acgc_fs_ensure_user_dirs(&roots);
    check_status("created Application Support, cache, and logs", status, ACGC_FS_OK);

    app_support = acgc_fs_root_path(&roots, ACGC_FS_APPLICATION_SUPPORT);
    cache = acgc_fs_root_path(&roots, ACGC_FS_CACHE);
    logs = acgc_fs_root_path(&roots, ACGC_FS_LOGS);
    check_true("Application Support is private", directory_mode_is(app_support, 0700));
    check_true("cache is private", directory_mode_is(cache, 0700));
    check_true("logs are private", directory_mode_is(logs, 0700));

    status = acgc_fs_join(&roots, ACGC_FS_RESOURCES, "Animal Crossing (USA).iso", path,
                          sizeof(path));
    check_status("resolved bundle resource", status, ACGC_FS_OK);
    check_true("bundle resource remains under Resources", strcmp(path, iso_path) == 0);
    status = acgc_fs_join(&roots, ACGC_FS_APPLICATION_SUPPORT, "../escape", path, sizeof(path));
    check_status("rejected parent traversal", status, ACGC_FS_PATH_INVALID);
    status = acgc_fs_join(&roots, ACGC_FS_CACHE, "/absolute", path, sizeof(path));
    check_status("rejected absolute path", status, ACGC_FS_PATH_INVALID);

    status = acgc_fs_write_atomic(&roots, ACGC_FS_RESOURCES, "forbidden.bin", cache_bytes,
                                  sizeof(cache_bytes), 0600, &report);
    check_status("rejected writes to bundle resources", status, ACGC_FS_PERMISSION);

    status = acgc_fs_write_atomic(&roots, ACGC_FS_CACHE, "fixture/cache.bin", cache_bytes,
                                  sizeof(cache_bytes), 0600, &report);
    check_status("wrote cache fixture", status, ACGC_FS_OK);
    check_true("cache write used data fsync", report.data_fsync != 0);
    check_true("cache write used F_FULLFSYNC", report.full_fsync != 0);
    check_true("cache write synced containing directory", report.directory_fsync != 0);
    status = acgc_fs_join(&roots, ACGC_FS_CACHE, "fixture/cache.bin", path, sizeof(path));
    check_status("resolved cache fixture", status, ACGC_FS_OK);
    check_true("cache file has private mode", file_mode_is(path, 0600));

    status = acgc_fs_write_atomic(&roots, ACGC_FS_LOGS, "session.log", log_bytes,
                                  sizeof(log_bytes) - 1, 0600, &report);
    check_status("wrote logs fixture", status, ACGC_FS_OK);
    status = acgc_fs_join(&roots, ACGC_FS_LOGS, "session.log", path, sizeof(path));
    check_status("resolved logs fixture", status, ACGC_FS_OK);
    check_true("log file has private mode", file_mode_is(path, 0600));

    status = acgc_save_write_atomic(&roots, "slot-a", payload_a, sizeof(payload_a), &report);
    check_status("atomically wrote first opaque save", status, ACGC_FS_OK);
    check_true("save write used data fsync", report.data_fsync != 0);
    check_true("save write used F_FULLFSYNC", report.full_fsync != 0);
    check_true("save write synced containing directory", report.directory_fsync != 0);
    status = acgc_fs_join(&roots, ACGC_FS_APPLICATION_SUPPORT, "saves/slot-a.sav", save_path,
                          sizeof(save_path));
    check_status("resolved Application Support save", status, ACGC_FS_OK);
    check_true("save has private mode", file_mode_is(save_path, 0600));
    status = acgc_fs_join(&roots, ACGC_FS_APPLICATION_SUPPORT, "saves", path, sizeof(path));
    check_status("resolved save directory", status, ACGC_FS_OK);
    check_true("successful save leaves no temporary file", count_temporary_files(path) == 0);

    status = acgc_save_read_verified(&roots, "slot-a", output, sizeof(output), &output_length);
    check_status("verified first opaque save", status, ACGC_FS_OK);
    check_true("first opaque save round-tripped", output_length == sizeof(payload_a) &&
                                                   memcmp(output, payload_a, sizeof(payload_a)) == 0);
    status = acgc_save_read_verified(&roots, "slot-a", output, 1, &output_length);
    check_status("rejected undersized save output buffer", status, ACGC_FS_BUFFER_TOO_SMALL);

    status = acgc_save_write_atomic(&roots, "slot-a", payload_b, sizeof(payload_b) - 1, &report);
    check_status("atomically replaced opaque save", status, ACGC_FS_OK);
    status = acgc_save_read_verified(&roots, "slot-a", output, sizeof(output), &output_length);
    check_status("verified replaced opaque save", status, ACGC_FS_OK);
    check_true("replacement is visible only after verified rename",
               output_length == sizeof(payload_b) - 1 &&
                   memcmp(output, payload_b, sizeof(payload_b) - 1) == 0);

    snprintf(temporary_path, sizeof(temporary_path), "%s/.slot-a.sav.tmp.injected",
             path);
    check_true("created ignored interrupted temp artifact",
               write_direct(temporary_path, malformed, sizeof(malformed)));
    status = acgc_save_read_verified(&roots, "slot-a", output, sizeof(output), &output_length);
    check_status("ignored unrenamed temp artifact", status, ACGC_FS_OK);
    check_true("unrenamed temp artifact did not replace save",
               output_length == sizeof(payload_b) - 1 &&
                   memcmp(output, payload_b, sizeof(payload_b) - 1) == 0);
    check_true("removed injected temp artifact", unlink(temporary_path) == 0);

    check_true("corrupted final byte", flip_last_byte(save_path));
    status = acgc_save_read_verified(&roots, "slot-a", output, sizeof(output), &output_length);
    check_status("rejected checksum corruption", status, ACGC_FS_CORRUPT);
    check_true("restored save after corruption test",
               acgc_save_write_atomic(&roots, "slot-a", payload_b, sizeof(payload_b) - 1,
                                      &report) == ACGC_FS_OK);
    check_true("truncated save fixture", write_direct(save_path, malformed, sizeof(malformed) - 3));
    status = acgc_save_read_verified(&roots, "slot-a", output, sizeof(output), &output_length);
    check_status("rejected truncated envelope", status, ACGC_FS_CORRUPT);
    check_true("restored save after truncation test",
               acgc_save_write_atomic(&roots, "slot-a", payload_b, sizeof(payload_b) - 1,
                                      &report) == ACGC_FS_OK);

    status = acgc_save_write_atomic(&roots, "../escape", payload_a, sizeof(payload_a), &report);
    check_status("rejected traversal save slot", status, ACGC_FS_PATH_INVALID);
    status = acgc_save_write_atomic(&roots, "slot/name", payload_a, sizeof(payload_a), &report);
    check_status("rejected slash in save slot", status, ACGC_FS_PATH_INVALID);

    snprintf(outside_iso_path, sizeof(outside_iso_path), "%s/Animal Crossing (USA).iso",
             app_support);
    check_true("did not copy ISO into Application Support", access(outside_iso_path, F_OK) != 0);
    snprintf(outside_iso_path, sizeof(outside_iso_path), "%s/Animal Crossing (USA).iso", cache);
    check_true("did not copy ISO into cache", access(outside_iso_path, F_OK) != 0);
    snprintf(outside_iso_path, sizeof(outside_iso_path), "%s/Animal Crossing (USA).iso", logs);
    check_true("did not copy ISO into logs", access(outside_iso_path, F_OK) != 0);
    check_true("lane contains only its synthetic ISO sentinel", count_iso_files(run_root) == 1);

    unsetenv("CFFIXED_USER_HOME");
    if (failures != 0) {
        fprintf(stderr, "Filesystem adapter verification FAILED (%d checks)\n", failures);
        return 1;
    }
    printf("Filesystem adapter verification PASSED\n");
    printf("  roots: Resources (read-only role), Application Support, Caches, Logs\n");
    printf("  saves: opaque envelope, checksum corruption/truncation rejection\n");
    printf("  atomicity: same-directory temp, data fsync, F_FULLFSYNC, rename, directory fsync\n");
    printf("  isolation: synthetic ISO sentinel was not copied outside bundle Resources\n");
    printf("  test_root: %s\n", run_root);
    return 0;
}
