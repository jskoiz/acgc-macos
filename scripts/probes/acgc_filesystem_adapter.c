#include "acgc_filesystem_adapter.h"

#if !defined(__APPLE__)
#error "acgc_filesystem_adapter requires an Apple filesystem host"
#endif

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#if !defined(F_FULLFSYNC)
#error "macOS F_FULLFSYNC is required for durable save commits"
#endif

enum {
    ACGC_SAVE_HEADER_SIZE = 16,
    ACGC_SAVE_VERSION = 1
};

static const uint8_t k_save_magic[4] = {'A', 'C', 'G', 'S'};

static void clear_report(acgc_fs_durability_report *report)
{
    if (report != NULL) {
        report->data_fsync = 0;
        report->full_fsync = 0;
        report->directory_fsync = 0;
    }
}

static int copy_absolute_path(char *destination, const char *source)
{
    size_t length;

    if (destination == NULL || source == NULL || source[0] != '/') {
        return 0;
    }

    length = strlen(source);
    while (length > 1 && source[length - 1] == '/') {
        --length;
    }
    if (length == 0 || length >= PATH_MAX) {
        return 0;
    }

    memcpy(destination, source, length);
    destination[length] = '\0';
    return 1;
}

static int valid_component(const char *component)
{
    const unsigned char *cursor = (const unsigned char *)component;

    if (component == NULL || *component == '\0' || strcmp(component, ".") == 0 ||
        strcmp(component, "..") == 0) {
        return 0;
    }

    while (*cursor != '\0') {
        if (*cursor == '/' || *cursor < 0x20) {
            return 0;
        }
        ++cursor;
    }
    return 1;
}

static int valid_relative_path(const char *relative_path)
{
    const char *component_start;
    const char *cursor;
    char component[PATH_MAX];
    size_t component_length;

    if (relative_path == NULL || relative_path[0] == '/' || relative_path[0] == '\0') {
        return 0;
    }

    component_start = relative_path;
    cursor = relative_path;
    for (;;) {
        if (*cursor == '/' || *cursor == '\0') {
            component_length = (size_t)(cursor - component_start);
            if (component_length == 0 || component_length >= sizeof(component)) {
                return 0;
            }
            memcpy(component, component_start, component_length);
            component[component_length] = '\0';
            if (!valid_component(component)) {
                return 0;
            }
            if (*cursor == '\0') {
                return 1;
            }
            component_start = cursor + 1;
        }
        ++cursor;
    }
}

static int valid_bundle_identifier(const char *bundle_identifier)
{
    const unsigned char *cursor;

    if (bundle_identifier == NULL || bundle_identifier[0] == '\0') {
        return 0;
    }
    cursor = (const unsigned char *)bundle_identifier;
    while (*cursor != '\0') {
        if (!((*cursor >= 'a' && *cursor <= 'z') ||
              (*cursor >= 'A' && *cursor <= 'Z') ||
              (*cursor >= '0' && *cursor <= '9') || *cursor == '.' || *cursor == '-' ||
              *cursor == '_')) {
            return 0;
        }
        ++cursor;
    }
    return 1;
}

static int append_path(char *destination,
                       size_t destination_size,
                       const char *prefix,
                       const char *suffix)
{
    int written;

    written = snprintf(destination, destination_size, "%s/%s", prefix, suffix);
    return written >= 0 && (size_t)written < destination_size;
}

static int directory_exists(const char *path)
{
    struct stat info;

    return stat(path, &info) == 0 && S_ISDIR(info.st_mode);
}

static int mkdir_p(const char *path, mode_t mode)
{
    char working[PATH_MAX];
    char *cursor;

    if (!copy_absolute_path(working, path)) {
        return 0;
    }

    for (cursor = working + 1; ; ++cursor) {
        char original = *cursor;

        if (original != '/' && original != '\0') {
            continue;
        }

        if (original == '/') {
            *cursor = '\0';
        }
        if (mkdir(working, mode) != 0 && errno != EEXIST) {
            return 0;
        }
        if (!directory_exists(working)) {
            return 0;
        }
        if (original == '\0') {
            break;
        }
        *cursor = '/';
    }
    return 1;
}

static const char *root_for_role(const acgc_fs_roots *roots, acgc_fs_role role)
{
    if (roots == NULL) {
        return NULL;
    }
    switch (role) {
    case ACGC_FS_RESOURCES:
        return roots->resources;
    case ACGC_FS_APPLICATION_SUPPORT:
        return roots->application_support;
    case ACGC_FS_CACHE:
        return roots->cache;
    case ACGC_FS_LOGS:
        return roots->logs;
    default:
        return NULL;
    }
}

const char *acgc_fs_root_path(const acgc_fs_roots *roots, acgc_fs_role role)
{
    return root_for_role(roots, role);
}

const char *acgc_fs_role_name(acgc_fs_role role)
{
    switch (role) {
    case ACGC_FS_RESOURCES:
        return "bundle-resources";
    case ACGC_FS_APPLICATION_SUPPORT:
        return "application-support";
    case ACGC_FS_CACHE:
        return "cache";
    case ACGC_FS_LOGS:
        return "logs";
    default:
        return "unknown-role";
    }
}

const char *acgc_fs_status_name(acgc_fs_status status)
{
    switch (status) {
    case ACGC_FS_OK:
        return "ok";
    case ACGC_FS_INVALID_ARGUMENT:
        return "invalid-argument";
    case ACGC_FS_PATH_INVALID:
        return "path-invalid";
    case ACGC_FS_PERMISSION:
        return "permission";
    case ACGC_FS_IO:
        return "io";
    case ACGC_FS_CORRUPT:
        return "corrupt";
    case ACGC_FS_TOO_LARGE:
        return "too-large";
    case ACGC_FS_BUFFER_TOO_SMALL:
        return "buffer-too-small";
    case ACGC_FS_DURABILITY_UNAVAILABLE:
        return "durability-unavailable";
    default:
        return "unknown-status";
    }
}

acgc_fs_status acgc_fs_roots_init(acgc_fs_roots *roots,
                                  const char *bundle_resources,
                                  const char *application_support,
                                  const char *cache,
                                  const char *logs)
{
    if (roots == NULL || bundle_resources == NULL || application_support == NULL ||
        cache == NULL || logs == NULL) {
        return ACGC_FS_INVALID_ARGUMENT;
    }
    if (!copy_absolute_path(roots->resources, bundle_resources) ||
        !copy_absolute_path(roots->application_support, application_support) ||
        !copy_absolute_path(roots->cache, cache) || !copy_absolute_path(roots->logs, logs)) {
        return ACGC_FS_PATH_INVALID;
    }
    if (!directory_exists(roots->resources)) {
        return ACGC_FS_IO;
    }
    if (strcmp(roots->resources, roots->application_support) == 0 ||
        strcmp(roots->resources, roots->cache) == 0 ||
        strcmp(roots->resources, roots->logs) == 0 ||
        strcmp(roots->application_support, roots->cache) == 0 ||
        strcmp(roots->application_support, roots->logs) == 0 ||
        strcmp(roots->cache, roots->logs) == 0) {
        return ACGC_FS_PATH_INVALID;
    }
    return ACGC_FS_OK;
}

acgc_fs_status acgc_fs_macos_roots_init(acgc_fs_roots *roots,
                                        const char *bundle_resources,
                                        const char *bundle_identifier)
{
    const char *home;
    char application_support_base[PATH_MAX];
    char cache_base[PATH_MAX];
    char logs_base[PATH_MAX];
    char application_support[PATH_MAX];
    char cache[PATH_MAX];
    char logs[PATH_MAX];

    if (roots == NULL || bundle_resources == NULL || !valid_bundle_identifier(bundle_identifier)) {
        return ACGC_FS_INVALID_ARGUMENT;
    }

    home = getenv("CFFIXED_USER_HOME");
    if (home == NULL || home[0] == '\0') {
        home = getenv("HOME");
    }
    if (home == NULL || home[0] != '/') {
        return ACGC_FS_PATH_INVALID;
    }

    if (!append_path(application_support_base, sizeof(application_support_base), home,
                     "Library/Application Support") ||
        !append_path(application_support, sizeof(application_support), application_support_base,
                     bundle_identifier) ||
        !append_path(cache_base, sizeof(cache_base), home, "Library/Caches") ||
        !append_path(cache, sizeof(cache), cache_base, bundle_identifier) ||
        !append_path(logs_base, sizeof(logs_base), home, "Library/Logs") ||
        !append_path(logs, sizeof(logs), logs_base, bundle_identifier)) {
        return ACGC_FS_PATH_INVALID;
    }

    return acgc_fs_roots_init(roots, bundle_resources, application_support, cache, logs);
}

acgc_fs_status acgc_fs_ensure_user_dirs(const acgc_fs_roots *roots)
{
    if (roots == NULL) {
        return ACGC_FS_INVALID_ARGUMENT;
    }
    if (!mkdir_p(roots->application_support, 0700) || !mkdir_p(roots->cache, 0700) ||
        !mkdir_p(roots->logs, 0700)) {
        return ACGC_FS_IO;
    }
    return ACGC_FS_OK;
}

acgc_fs_status acgc_fs_join(const acgc_fs_roots *roots,
                            acgc_fs_role role,
                            const char *relative_path,
                            char *output,
                            size_t output_size)
{
    const char *root;
    int written;

    if (roots == NULL || output == NULL || output_size == 0) {
        return ACGC_FS_INVALID_ARGUMENT;
    }
    root = root_for_role(roots, role);
    if (root == NULL || !valid_relative_path(relative_path)) {
        return ACGC_FS_PATH_INVALID;
    }

    written = snprintf(output, output_size, "%s/%s", root, relative_path);
    if (written < 0 || (size_t)written >= output_size) {
        return ACGC_FS_PATH_INVALID;
    }
    return ACGC_FS_OK;
}

static int write_all(int file_descriptor, const uint8_t *bytes, size_t length)
{
    size_t offset = 0;

    while (offset < length) {
        ssize_t written = write(file_descriptor, bytes + offset, length - offset);
        if (written < 0 && errno == EINTR) {
            continue;
        }
        if (written <= 0) {
            return 0;
        }
        offset += (size_t)written;
    }
    return 1;
}

static int read_all(int file_descriptor, uint8_t *bytes, size_t length)
{
    size_t offset = 0;

    while (offset < length) {
        ssize_t count = read(file_descriptor, bytes + offset, length - offset);
        if (count < 0 && errno == EINTR) {
            continue;
        }
        if (count <= 0) {
            return count == 0 ? 0 : -1;
        }
        offset += (size_t)count;
    }
    return 1;
}

static acgc_fs_status sync_data_durable(int file_descriptor,
                                        acgc_fs_durability_report *report)
{
    if (fsync(file_descriptor) != 0) {
        return ACGC_FS_IO;
    }
    if (report != NULL) {
        report->data_fsync = 1;
    }
    if (fcntl(file_descriptor, F_FULLFSYNC) != 0) {
        return ACGC_FS_DURABILITY_UNAVAILABLE;
    }
    if (report != NULL) {
        report->full_fsync = 1;
    }
    return ACGC_FS_OK;
}

static acgc_fs_status sync_directory(const char *directory,
                                     acgc_fs_durability_report *report)
{
    int directory_flags = O_RDONLY;
    int file_descriptor;

#if defined(O_DIRECTORY)
    directory_flags |= O_DIRECTORY;
#endif
#if defined(O_CLOEXEC)
    directory_flags |= O_CLOEXEC;
#endif
    file_descriptor = open(directory, directory_flags);
    if (file_descriptor < 0) {
        return ACGC_FS_IO;
    }
    if (fsync(file_descriptor) != 0) {
        (void)close(file_descriptor);
        return ACGC_FS_IO;
    }
    if (close(file_descriptor) != 0) {
        return ACGC_FS_IO;
    }
    if (report != NULL) {
        report->directory_fsync = 1;
    }
    return ACGC_FS_OK;
}

static acgc_fs_status parent_directory(const char *path, char *directory, size_t directory_size)
{
    const char *last_slash;
    size_t length;

    last_slash = strrchr(path, '/');
    if (last_slash == NULL) {
        return ACGC_FS_PATH_INVALID;
    }
    length = (size_t)(last_slash - path);
    if (length == 0) {
        length = 1;
    }
    if (length >= directory_size) {
        return ACGC_FS_PATH_INVALID;
    }
    memcpy(directory, path, length);
    directory[length] = '\0';
    return ACGC_FS_OK;
}

static acgc_fs_status atomic_write_path(const char *path,
                                        const uint8_t *bytes,
                                        size_t length,
                                        mode_t mode,
                                        acgc_fs_durability_report *report)
{
    char directory[PATH_MAX];
    char temporary[PATH_MAX];
    const char *base_name;
    int file_descriptor;
    int written;
    acgc_fs_status status;

    clear_report(report);
    if (path == NULL || (bytes == NULL && length != 0)) {
        return ACGC_FS_INVALID_ARGUMENT;
    }
    status = parent_directory(path, directory, sizeof(directory));
    if (status != ACGC_FS_OK) {
        return status;
    }
    if (!mkdir_p(directory, 0700)) {
        return ACGC_FS_IO;
    }
    base_name = strrchr(path, '/') + 1;
    if (!valid_component(base_name)) {
        return ACGC_FS_PATH_INVALID;
    }
    written = snprintf(temporary, sizeof(temporary), "%s/.%s.tmp.XXXXXX", directory, base_name);
    if (written < 0 || (size_t)written >= sizeof(temporary)) {
        return ACGC_FS_PATH_INVALID;
    }

    file_descriptor = mkstemp(temporary);
    if (file_descriptor < 0) {
        return ACGC_FS_IO;
    }
    if (fchmod(file_descriptor, mode) != 0 || !write_all(file_descriptor, bytes, length)) {
        (void)close(file_descriptor);
        (void)unlink(temporary);
        return ACGC_FS_IO;
    }

    status = sync_data_durable(file_descriptor, report);
    if (close(file_descriptor) != 0 && status == ACGC_FS_OK) {
        status = ACGC_FS_IO;
    }
    if (status != ACGC_FS_OK) {
        (void)unlink(temporary);
        return status;
    }

    if (rename(temporary, path) != 0) {
        (void)unlink(temporary);
        return ACGC_FS_IO;
    }

    status = sync_directory(directory, report);
    if (status != ACGC_FS_OK) {
        return status;
    }
    return ACGC_FS_OK;
}

acgc_fs_status acgc_fs_write_atomic(const acgc_fs_roots *roots,
                                    acgc_fs_role role,
                                    const char *relative_path,
                                    const uint8_t *bytes,
                                    size_t length,
                                    mode_t mode,
                                    acgc_fs_durability_report *report)
{
    char path[PATH_MAX];
    acgc_fs_status status;

    clear_report(report);
    if (role == ACGC_FS_RESOURCES) {
        return ACGC_FS_PERMISSION;
    }
    status = acgc_fs_join(roots, role, relative_path, path, sizeof(path));
    if (status != ACGC_FS_OK) {
        return status;
    }
    status = acgc_fs_ensure_user_dirs(roots);
    if (status != ACGC_FS_OK) {
        return status;
    }
    return atomic_write_path(path, bytes, length, mode, report);
}

static int valid_slot_name(const char *slot_name)
{
    const unsigned char *cursor;

    if (!valid_component(slot_name) || strchr(slot_name, '/') != NULL) {
        return 0;
    }
    cursor = (const unsigned char *)slot_name;
    while (*cursor != '\0') {
        if (!((*cursor >= 'a' && *cursor <= 'z') ||
              (*cursor >= 'A' && *cursor <= 'Z') ||
              (*cursor >= '0' && *cursor <= '9') || *cursor == '.' || *cursor == '_' ||
              *cursor == '-')) {
            return 0;
        }
        ++cursor;
    }
    return strlen(slot_name) <= 64;
}

static void store_le16(uint8_t *destination, uint16_t value)
{
    destination[0] = (uint8_t)(value & 0xffu);
    destination[1] = (uint8_t)((value >> 8) & 0xffu);
}

static void store_le32(uint8_t *destination, uint32_t value)
{
    destination[0] = (uint8_t)(value & 0xffu);
    destination[1] = (uint8_t)((value >> 8) & 0xffu);
    destination[2] = (uint8_t)((value >> 16) & 0xffu);
    destination[3] = (uint8_t)((value >> 24) & 0xffu);
}

static uint16_t load_le16(const uint8_t *source)
{
    return (uint16_t)source[0] | (uint16_t)((uint16_t)source[1] << 8);
}

static uint32_t load_le32(const uint8_t *source)
{
    return (uint32_t)source[0] | ((uint32_t)source[1] << 8) | ((uint32_t)source[2] << 16) |
           ((uint32_t)source[3] << 24);
}

static uint32_t crc32(const uint8_t *bytes, size_t length)
{
    uint32_t crc = 0xffffffffu;
    size_t index;

    for (index = 0; index < length; ++index) {
        unsigned int bit;
        crc ^= bytes[index];
        for (bit = 0; bit < 8; ++bit) {
            crc = (crc >> 1) ^ (0xedb88320u & (uint32_t)-(int)(crc & 1u));
        }
    }
    return crc ^ 0xffffffffu;
}

static acgc_fs_status save_path(const acgc_fs_roots *roots,
                                const char *slot_name,
                                char *path,
                                size_t path_size)
{
    char relative_path[PATH_MAX];
    int written;

    if (!valid_slot_name(slot_name)) {
        return ACGC_FS_PATH_INVALID;
    }
    written = snprintf(relative_path, sizeof(relative_path), "saves/%s.sav", slot_name);
    if (written < 0 || (size_t)written >= sizeof(relative_path)) {
        return ACGC_FS_PATH_INVALID;
    }
    return acgc_fs_join(roots, ACGC_FS_APPLICATION_SUPPORT, relative_path, path, path_size);
}

acgc_fs_status acgc_save_write_atomic(const acgc_fs_roots *roots,
                                      const char *slot_name,
                                      const uint8_t *payload,
                                      size_t payload_length,
                                      acgc_fs_durability_report *report)
{
    char path[PATH_MAX];
    uint8_t *record;
    size_t record_length;
    acgc_fs_status status;

    clear_report(report);
    if (payload == NULL && payload_length != 0) {
        return ACGC_FS_INVALID_ARGUMENT;
    }
    if (payload_length > ACGC_FS_MAX_SAVE_BYTES) {
        return ACGC_FS_TOO_LARGE;
    }
    status = save_path(roots, slot_name, path, sizeof(path));
    if (status != ACGC_FS_OK) {
        return status;
    }

    record_length = ACGC_SAVE_HEADER_SIZE + payload_length;
    record = (uint8_t *)malloc(record_length == 0 ? 1 : record_length);
    if (record == NULL) {
        return ACGC_FS_IO;
    }
    memcpy(record, k_save_magic, sizeof(k_save_magic));
    store_le16(record + 4, ACGC_SAVE_VERSION);
    store_le16(record + 6, ACGC_SAVE_HEADER_SIZE);
    store_le32(record + 8, (uint32_t)payload_length);
    store_le32(record + 12, crc32(payload, payload_length));
    if (payload_length != 0) {
        memcpy(record + ACGC_SAVE_HEADER_SIZE, payload, payload_length);
    }

    status = acgc_fs_ensure_user_dirs(roots);
    if (status == ACGC_FS_OK) {
        status = atomic_write_path(path, record, record_length, 0600, report);
    }
    free(record);
    return status;
}

static int open_read_only_no_follow(const char *path)
{
    int flags = O_RDONLY;

#if defined(O_NOFOLLOW)
    flags |= O_NOFOLLOW;
#endif
#if defined(O_CLOEXEC)
    flags |= O_CLOEXEC;
#endif
    return open(path, flags);
}

acgc_fs_status acgc_save_read_verified(const acgc_fs_roots *roots,
                                       const char *slot_name,
                                       uint8_t *payload,
                                       size_t payload_capacity,
                                       size_t *payload_length)
{
    char path[PATH_MAX];
    uint8_t header[ACGC_SAVE_HEADER_SIZE];
    struct stat info;
    uint32_t encoded_length;
    uint32_t expected_crc;
    uint64_t expected_file_size;
    int file_descriptor;
    int read_result;
    acgc_fs_status status;

    if (payload_length == NULL || (payload == NULL && payload_capacity != 0)) {
        return ACGC_FS_INVALID_ARGUMENT;
    }
    *payload_length = 0;
    status = save_path(roots, slot_name, path, sizeof(path));
    if (status != ACGC_FS_OK) {
        return status;
    }
    file_descriptor = open_read_only_no_follow(path);
    if (file_descriptor < 0) {
        return ACGC_FS_IO;
    }
    if (fstat(file_descriptor, &info) != 0 || !S_ISREG(info.st_mode) || info.st_size < 0) {
        (void)close(file_descriptor);
        return ACGC_FS_CORRUPT;
    }
    if ((uint64_t)info.st_size < ACGC_SAVE_HEADER_SIZE ||
        (uint64_t)info.st_size > (uint64_t)ACGC_SAVE_HEADER_SIZE + ACGC_FS_MAX_SAVE_BYTES) {
        (void)close(file_descriptor);
        return ACGC_FS_CORRUPT;
    }
    read_result = read_all(file_descriptor, header, sizeof(header));
    if (read_result != 1 || memcmp(header, k_save_magic, sizeof(k_save_magic)) != 0 ||
        load_le16(header + 4) != ACGC_SAVE_VERSION ||
        load_le16(header + 6) != ACGC_SAVE_HEADER_SIZE) {
        (void)close(file_descriptor);
        return ACGC_FS_CORRUPT;
    }

    encoded_length = load_le32(header + 8);
    expected_crc = load_le32(header + 12);
    if (encoded_length > ACGC_FS_MAX_SAVE_BYTES) {
        (void)close(file_descriptor);
        return ACGC_FS_CORRUPT;
    }
    expected_file_size = (uint64_t)ACGC_SAVE_HEADER_SIZE + encoded_length;
    if ((uint64_t)info.st_size != expected_file_size) {
        (void)close(file_descriptor);
        return ACGC_FS_CORRUPT;
    }
    if ((size_t)encoded_length > payload_capacity) {
        (void)close(file_descriptor);
        return ACGC_FS_BUFFER_TOO_SMALL;
    }
    read_result = read_all(file_descriptor, payload, (size_t)encoded_length);
    if (close(file_descriptor) != 0 || read_result != 1) {
        return read_result == 0 ? ACGC_FS_CORRUPT : ACGC_FS_IO;
    }
    if (crc32(payload, (size_t)encoded_length) != expected_crc) {
        return ACGC_FS_CORRUPT;
    }
    *payload_length = (size_t)encoded_length;
    return ACGC_FS_OK;
}
