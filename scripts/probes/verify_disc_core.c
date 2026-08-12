#include "acgc/boot_source.h"

#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/types.h>

static int read_disc(
    void* context,
    uint32_t offset,
    void* destination,
    size_t size
) {
    FILE* disc = (FILE*)context;

    return fseeko(disc, (off_t)offset, SEEK_SET) == 0 &&
           fread(destination, 1, size, disc) == size;
}

static int write_file(const char* path, const uint8_t* data, uint32_t size) {
    FILE* output = fopen(path, "wb");
    int ok;

    if (output == NULL) {
        return 0;
    }
    ok = fwrite(data, 1, size, output) == size;
    if (fclose(output) != 0) {
        ok = 0;
    }
    return ok;
}

int main(int argc, char** argv) {
    FILE* disc;
    off_t disc_size;
    AcgcDiscReader reader;
    AcgcBootSourceImages images = {0};
    AcgcBootSourceStatus status;

    if (argc != 3) {
        fprintf(stderr, "usage: verify_disc_core DISC OUTPUT_REL\n");
        return 2;
    }

    disc = fopen(argv[1], "rb");
    if (disc == NULL || fseeko(disc, 0, SEEK_END) != 0) {
        fprintf(stderr, "unable to open or seek disc input\n");
        if (disc != NULL) {
            fclose(disc);
        }
        return 1;
    }
    disc_size = ftello(disc);
    if (disc_size <= 0 || (uint64_t)disc_size > UINT32_MAX ||
        fseeko(disc, 0, SEEK_SET) != 0) {
        fprintf(stderr, "disc input has an unsupported size\n");
        fclose(disc);
        return 1;
    }

    reader.context = disc;
    reader.size = (uint32_t)disc_size;
    reader.read = read_disc;

    status = acgc_boot_source_prepare(&reader, NULL, &images);
    fclose(disc);

    if (status != ACGC_BOOT_SOURCE_OK) {
        fprintf(
            stderr,
            "boot-source verification failed: %s\n",
            acgc_boot_source_status_string(status)
        );
        acgc_boot_source_dispose(&images);
        return 1;
    }
    if (!write_file(argv[2], images.rel_data, images.rel_size)) {
        fprintf(stderr, "unable to write temporary REL evidence\n");
        acgc_boot_source_dispose(&images);
        return 1;
    }

    printf(
        "gcm=ok dol_size=%" PRIu32 " fst_files=%" PRIu32
        " rel_entries=%" PRIu32 " rel_input=%" PRIu32
        " rel_output=%" PRIu32 " rel_format=%s\n",
        images.manifest.dol_size,
        images.manifest.fst_file_count,
        UINT32_C(1),
        images.manifest.rel_input_size,
        images.rel_size,
        images.rel_format == ACGC_REL_YAZ0 ? "yaz0" : "raw"
    );
    acgc_boot_source_dispose(&images);
    return 0;
}
