#ifndef ACGC_FILESYSTEM_ADAPTER_H
#define ACGC_FILESYSTEM_ADAPTER_H

#include <stddef.h>
#include <stdint.h>
#include <sys/types.h>

#ifndef PATH_MAX
#define PATH_MAX 1024
#endif

#define ACGC_FS_MAX_SAVE_BYTES (16u * 1024u * 1024u)

typedef enum acgc_fs_role {
    ACGC_FS_RESOURCES = 0,
    ACGC_FS_APPLICATION_SUPPORT = 1,
    ACGC_FS_CACHE = 2,
    ACGC_FS_LOGS = 3
} acgc_fs_role;

typedef enum acgc_fs_status {
    ACGC_FS_OK = 0,
    ACGC_FS_INVALID_ARGUMENT = 1,
    ACGC_FS_PATH_INVALID = 2,
    ACGC_FS_PERMISSION = 3,
    ACGC_FS_IO = 4,
    ACGC_FS_CORRUPT = 5,
    ACGC_FS_TOO_LARGE = 6,
    ACGC_FS_BUFFER_TOO_SMALL = 7,
    ACGC_FS_DURABILITY_UNAVAILABLE = 8
} acgc_fs_status;

typedef struct acgc_fs_roots {
    char resources[PATH_MAX];
    char application_support[PATH_MAX];
    char cache[PATH_MAX];
    char logs[PATH_MAX];
} acgc_fs_roots;

typedef struct acgc_fs_durability_report {
    int data_fsync;
    int full_fsync;
    int directory_fsync;
} acgc_fs_durability_report;

/*
 * The host supplies the bundle's Resources directory. The user roots are
 * derived from the sandbox/container home using Apple's conventional layout:
 * Library/Application Support, Library/Caches, and Library/Logs.
 */
acgc_fs_status acgc_fs_macos_roots_init(acgc_fs_roots *roots,
                                        const char *bundle_resources,
                                        const char *bundle_identifier);

acgc_fs_status acgc_fs_roots_init(acgc_fs_roots *roots,
                                  const char *bundle_resources,
                                  const char *application_support,
                                  const char *cache,
                                  const char *logs);

acgc_fs_status acgc_fs_ensure_user_dirs(const acgc_fs_roots *roots);

const char *acgc_fs_root_path(const acgc_fs_roots *roots, acgc_fs_role role);
const char *acgc_fs_status_name(acgc_fs_status status);
const char *acgc_fs_role_name(acgc_fs_role role);

acgc_fs_status acgc_fs_join(const acgc_fs_roots *roots,
                            acgc_fs_role role,
                            const char *relative_path,
                            char *output,
                            size_t output_size);

/* Generic host files are used for cache and log records. */
acgc_fs_status acgc_fs_write_atomic(const acgc_fs_roots *roots,
                                    acgc_fs_role role,
                                    const char *relative_path,
                                    const uint8_t *bytes,
                                    size_t length,
                                    mode_t mode,
                                    acgc_fs_durability_report *report);

/*
 * Save persistence is an adapter envelope only. Its payload is opaque bytes;
 * GameCube Save_t/GCI serialization remains outside this module.
 */
acgc_fs_status acgc_save_write_atomic(const acgc_fs_roots *roots,
                                      const char *slot_name,
                                      const uint8_t *payload,
                                      size_t payload_length,
                                      acgc_fs_durability_report *report);

acgc_fs_status acgc_save_read_verified(const acgc_fs_roots *roots,
                                       const char *slot_name,
                                       uint8_t *payload,
                                       size_t payload_capacity,
                                       size_t *payload_length);

#endif
