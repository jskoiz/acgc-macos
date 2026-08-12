#include "acgc/disc.h"

#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

typedef struct DiscEvidence {
    uint32_t file_count;
    uint32_t rel_count;
    uint32_t rel_offset;
    uint32_t rel_size;
} DiscEvidence;

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

static int visit_file(
    void* context,
    const char* path,
    uint32_t offset,
    uint32_t size
) {
    DiscEvidence* evidence = (DiscEvidence*)context;

    evidence->file_count++;
    if (strcmp(path, "foresta.rel.szs") == 0) {
        evidence->rel_count++;
        evidence->rel_offset = offset;
        evidence->rel_size = size;
    }
    return 1;
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
    AcgcGcmInfo info;
    AcgcDiscStatus status;
    DiscEvidence evidence = {0};
    uint32_t dol_size = 0;
    uint8_t* rel_data = NULL;
    uint32_t rel_size = 0;
    AcgcRelFormat rel_format = ACGC_REL_RAW;

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

    status = acgc_gcm_parse(&reader, &info);
    if (status == ACGC_DISC_OK) {
        status = acgc_dol_get_size(&reader, info.dol_offset, &dol_size);
    }
    if (status == ACGC_DISC_OK) {
        status = acgc_fst_visit(&reader, &info, visit_file, &evidence);
    }
    if (status == ACGC_DISC_OK && evidence.rel_count == 1) {
        status = acgc_rel_extract(
            &reader,
            evidence.rel_offset,
            evidence.rel_size,
            NULL,
            &rel_data,
            &rel_size,
            &rel_format
        );
    }
    fclose(disc);

    if (status != ACGC_DISC_OK || evidence.rel_count != 1) {
        fprintf(
            stderr,
            "disc verification failed: %s; REL entries=%" PRIu32 "\n",
            acgc_disc_status_string(status),
            evidence.rel_count
        );
        free(rel_data);
        return 1;
    }
    if (!write_file(argv[2], rel_data, rel_size)) {
        fprintf(stderr, "unable to write temporary REL evidence\n");
        free(rel_data);
        return 1;
    }
    free(rel_data);

    printf(
        "gcm=ok dol_size=%" PRIu32 " fst_files=%" PRIu32
        " rel_entries=%" PRIu32 " rel_input=%" PRIu32
        " rel_output=%" PRIu32 " rel_format=%s\n",
        dol_size,
        evidence.file_count,
        evidence.rel_count,
        evidence.rel_size,
        rel_size,
        rel_format == ACGC_REL_YAZ0 ? "yaz0" : "raw"
    );
    return 0;
}
