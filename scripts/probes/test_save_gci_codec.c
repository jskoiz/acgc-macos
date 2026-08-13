#include <errno.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#include "pc_save_bswap.h"

enum {
    SAVE_T_SIZE_EXPECTED = 0x242A0,
    SAVE_ALIGNED_SIZE_EXPECTED = 0x26000,
    GCI_HEADER_SIZE_EXPECTED = 0x40,
    GCI_DATA_SIZE_EXPECTED = 0x72000,
    GCI_MAIN_OFFSET_EXPECTED = 0x26000,
    GCI_BACK_OFFSET_EXPECTED = 0x4C000,
    GCI_SECTOR_SIZE_EXPECTED = 0x2000,
    GCI_TOTAL_SIZE_EXPECTED = GCI_HEADER_SIZE_EXPECTED + GCI_DATA_SIZE_EXPECTED,
    NONCANONICAL_PADDING_OFFSET = 0x0000B6,
    NONCANONICAL_PADDING_SIZE = 2,
};

_Static_assert(sizeof(Save_t) == SAVE_T_SIZE_EXPECTED, "Save_t size changed");
_Static_assert(sizeof(Save) == SAVE_ALIGNED_SIZE_EXPECTED, "Save size changed");
_Static_assert(sizeof(CARDDir) == GCI_HEADER_SIZE_EXPECTED, "CARDDir size changed");
_Static_assert(mCD_LAND_SAVE_SIZE == GCI_DATA_SIZE_EXPECTED, "GCI data size changed");
_Static_assert(mCD_MEMCARD_SECTORSIZE == GCI_SECTOR_SIZE_EXPECTED, "GCI sector size changed");
_Static_assert(offsetof(Save_t, save_check) == 0x000000, "save_check offset changed");
_Static_assert(offsetof(Save_t, scene_no) == 0x000014, "scene_no offset changed");
_Static_assert(offsetof(Save_t, copy_protect) == 0x00001A, "copy_protect offset changed");
_Static_assert(offsetof(Save_t, private_data) == 0x000020, "private_data offset changed");
_Static_assert(offsetof(Save_t, land_info) == 0x009120, "land_info offset changed");
_Static_assert(offsetof(Save_t, homes) == 0x009CE8, "homes offset changed");
_Static_assert(offsetof(Save_t, _tmp6) == 0x0213E7, "_tmp6 offset changed");
_Static_assert(offsetof(Save_t, _tmp7) == 0x022500, "_tmp7 offset changed");
_Static_assert(offsetof(Save_t, _241A8) == 0x0241A8, "_241A8 offset changed");
_Static_assert(offsetof(Save_t, _241A8) + sizeof(((Save_t*)0)->_241A8) == SAVE_T_SIZE_EXPECTED,
               "Save_t tail size changed");
_Static_assert(offsetof(mQst_base_c, time_limit) == 0x000002,
               "quest time_limit offset changed");
_Static_assert(offsetof(Save_t, private_data) + offsetof(Private_c, deliveries) +
                   offsetof(mQst_delivery_c, base) + offsetof(mQst_base_c, time_limit) ==
                       NONCANONICAL_PADDING_OFFSET,
               "quest lost-range offset changed");
_Static_assert(NONCANONICAL_PADDING_OFFSET + NONCANONICAL_PADDING_SIZE <= SAVE_T_SIZE_EXPECTED,
               "quest lost range is outside Save_t");

/* pc_save_bswap.c references the decomp diagnostic symbol even though this
 * probe does not call its logging verification helpers. */
void OSReport(const char* format, ...) {
    (void)format;
}

typedef struct ByteRange {
    size_t offset;
    size_t size;
    const char* name;
} ByteRange;

static const ByteRange k_opaque_ranges[] = {
    {offsetof(Save_t, pad_1C), sizeof(((Save_t*)0)->pad_1C), "pad_1C"},
    {offsetof(Save_t, pad_9CE4), sizeof(((Save_t*)0)->pad_9CE4), "pad_9CE4"},
    {offsetof(Save_t, _tmp6), sizeof(((Save_t*)0)->_tmp6), "_tmp6"},
    {offsetof(Save_t, _tmp7), sizeof(((Save_t*)0)->_tmp7), "_tmp7"},
    {offsetof(Save_t, _2418B), sizeof(((Save_t*)0)->_2418B), "_2418B"},
    {offsetof(Save_t, _241A8), sizeof(((Save_t*)0)->_241A8), "_241A8"},
};

static void put_be16(uint8_t* destination, uint16_t value) {
    destination[0] = (uint8_t)(value >> 8);
    destination[1] = (uint8_t)value;
}

static void put_be32(uint8_t* destination, uint32_t value) {
    destination[0] = (uint8_t)(value >> 24);
    destination[1] = (uint8_t)(value >> 16);
    destination[2] = (uint8_t)(value >> 8);
    destination[3] = (uint8_t)value;
}

static uint16_t read_be16(const uint8_t* source) {
    return (uint16_t)(((uint16_t)source[0] << 8) | source[1]);
}

static uint32_t sum_be16(const uint8_t* data, size_t size) {
    uint32_t sum = 0;
    size_t i;

    for (i = 0; i < size; i += 2) {
        sum += read_be16(data + i);
    }
    return sum & UINT16_MAX;
}

static int write_exact(const char* path, const uint8_t* data, size_t size) {
    FILE* file = fopen(path, "wb");
    int ok = 0;

    if (file == NULL) {
        return 0;
    }
    if (fwrite(data, 1, size, file) == size && fflush(file) == 0 && fsync(fileno(file)) == 0) {
        ok = 1;
    }
    if (fclose(file) != 0) {
        ok = 0;
    }
    return ok;
}

static int read_exact(const char* path, uint8_t* data, size_t size) {
    FILE* file = fopen(path, "rb");
    long file_size;
    int ok;

    if (file == NULL || fseek(file, 0, SEEK_END) != 0) {
        if (file != NULL) {
            fclose(file);
        }
        return 0;
    }
    file_size = ftell(file);
    ok = file_size >= 0 && (size_t)file_size == size && fseek(file, 0, SEEK_SET) == 0 &&
         fread(data, 1, size, file) == size;
    if (fclose(file) != 0) {
        ok = 0;
    }
    return ok;
}

static int path_for(char* destination, size_t destination_size, const char* directory, const char* leaf) {
    int length = snprintf(destination, destination_size, "%s/%s", directory, leaf);
    return length >= 0 && (size_t)length < destination_size;
}

static int run_codec_process(const char* executable, const char* mode, const char* input, const char* output) {
    pid_t child = fork();
    int status;

    if (child < 0) {
        return 0;
    }
    if (child == 0) {
        execl(executable, executable, mode, input, output, (char*)NULL);
        _exit(127);
    }
    if (waitpid(child, &status, 0) != child) {
        return 0;
    }
    return WIFEXITED(status) && WEXITSTATUS(status) == 0;
}

static int run_child(const char* mode, const char* input, const char* output) {
    uint8_t* data = (uint8_t*)malloc(SAVE_T_SIZE_EXPECTED);

    if (data == NULL || !read_exact(input, data, SAVE_T_SIZE_EXPECTED)) {
        free(data);
        return 1;
    }
    if (strcmp(mode, "--from-be") == 0) {
        pc_save_bswap((Save_t*)data, PC_BSWAP_FROM_BE);
    } else if (strcmp(mode, "--to-be") == 0) {
        pc_save_bswap((Save_t*)data, PC_BSWAP_TO_BE);
    } else {
        free(data);
        return 2;
    }
    if (!write_exact(output, data, SAVE_T_SIZE_EXPECTED)) {
        free(data);
        return 1;
    }
    free(data);
    return 0;
}

static int check_opaque_ranges(const uint8_t* before, const uint8_t* after) {
    size_t i;

    for (i = 0; i < sizeof(k_opaque_ranges) / sizeof(k_opaque_ranges[0]); i++) {
        const ByteRange* range = &k_opaque_ranges[i];
        if (memcmp(before + range->offset, after + range->offset, range->size) != 0) {
            fprintf(stderr, "opaque range changed after BE->LE: %s\n", range->name);
            return 0;
        }
    }
    return 1;
}

static void set_fixture_scalars(uint8_t* data) {
    put_be32(data + offsetof(Save_t, scene_no), UINT32_C(0x11223344));
    put_be16(data + offsetof(Save_t, copy_protect), UINT16_C(0xA1B2));
}

static int set_fixture_checksum(uint8_t* data) {
    uint16_t checksum;

    /* The checksum is serialized as the final BE u16 of mFRm_chk_t. */
    put_be16(data + offsetof(Save_t, save_check) + offsetof(mFRm_chk_t, checksum), 0);
    checksum = pc_checksum_be(data, SAVE_T_SIZE_EXPECTED, 0);
    put_be16(data + offsetof(Save_t, save_check) + offsetof(mFRm_chk_t, checksum), checksum);

    return sum_be16(data, SAVE_T_SIZE_EXPECTED) == 0 &&
           pc_checksum_be(data, SAVE_T_SIZE_EXPECTED, checksum) == checksum;
}

static int make_fixture(uint8_t* data, int canonical_padding) {
    size_t i;

    if (canonical_padding) {
        memset(data, 0, SAVE_T_SIZE_EXPECTED);
        for (i = 0; i < sizeof(k_opaque_ranges) / sizeof(k_opaque_ranges[0]); i++) {
            size_t j;
            for (j = 0; j < k_opaque_ranges[i].size; j++) {
                data[k_opaque_ranges[i].offset + j] =
                    (uint8_t)((j * 29u + k_opaque_ranges[i].offset + 0x53u) & 0xFFu);
            }
        }
    } else {
        for (i = 0; i < SAVE_T_SIZE_EXPECTED; i++) {
            data[i] = (uint8_t)((i * 29u + (i >> 8) + 0x53u) & 0xFFu);
        }
    }
    set_fixture_scalars(data);
    return set_fixture_checksum(data);
}

static int run_parent(const char* executable, const char* directory) {
    uint8_t* original = NULL;
    uint8_t* little_endian = NULL;
    uint8_t* roundtripped = NULL;
    uint8_t small_checksum_fixture[] = {0x00, 0x01, 0x00, 0x02};
    char input_path[1024];
    char little_endian_path[1024];
    char roundtrip_path[1024];
    uint32_t scene_value;
    uint16_t copy_protect_value;
    uint16_t checksum;
    uint16_t noncanonical_padding_wire;
    uint16_t noncanonical_padding_roundtrip;
    int result = 1;

    if (!path_for(input_path, sizeof(input_path), directory, "save-gci.be") ||
        !path_for(little_endian_path, sizeof(little_endian_path), directory, "save-gci.le") ||
        !path_for(roundtrip_path, sizeof(roundtrip_path), directory, "save-gci.roundtrip.be")) {
        fprintf(stderr, "test path is too long\n");
        return 1;
    }

    original = (uint8_t*)malloc(SAVE_T_SIZE_EXPECTED);
    little_endian = (uint8_t*)malloc(SAVE_T_SIZE_EXPECTED);
    roundtripped = (uint8_t*)malloc(SAVE_T_SIZE_EXPECTED);
    if (original == NULL || little_endian == NULL || roundtripped == NULL) {
        fprintf(stderr, "fixture allocation failed\n");
        goto cleanup;
    }

    if (!make_fixture(original, 0)) {
        fprintf(stderr, "checksum fixture did not close over BE words\n");
        goto cleanup;
    }
    checksum = read_be16(original + offsetof(Save_t, save_check) + offsetof(mFRm_chk_t, checksum));
    if (pc_checksum_be(small_checksum_fixture, sizeof(small_checksum_fixture), 0) != UINT16_C(0xFFFD)) {
        fprintf(stderr, "known checksum vector failed\n");
        goto cleanup;
    }

    if (!write_exact(input_path, original, SAVE_T_SIZE_EXPECTED) ||
        !run_codec_process(executable, "--from-be", input_path, little_endian_path) ||
        !run_codec_process(executable, "--to-be", little_endian_path, roundtrip_path) ||
        !read_exact(roundtrip_path, roundtripped, SAVE_T_SIZE_EXPECTED)) {
        fprintf(stderr, "noncanonical padding child process failed\n");
        goto cleanup;
    }
    noncanonical_padding_wire = read_be16(original + NONCANONICAL_PADDING_OFFSET);
    noncanonical_padding_roundtrip = read_be16(roundtripped + NONCANONICAL_PADDING_OFFSET);
    if (memcmp(original, roundtripped, SAVE_T_SIZE_EXPECTED) == 0 ||
        noncanonical_padding_wire == 0 || noncanonical_padding_roundtrip != 0) {
        fprintf(stderr, "noncanonical padding unexpectedly round-tripped\n");
        goto cleanup;
    }
    printf("save_gci_noncanonical_padding_preservation: BLOCKED offset=0x%X size=%u wire=0x%04X roundtrip=0x%04X canonical=0x0000\n",
           NONCANONICAL_PADDING_OFFSET, NONCANONICAL_PADDING_SIZE,
           noncanonical_padding_wire, noncanonical_padding_roundtrip);

    if (!make_fixture(original, 1)) {
        fprintf(stderr, "canonical checksum fixture did not close over BE words\n");
        goto cleanup;
    }
    checksum = read_be16(original + offsetof(Save_t, save_check) + offsetof(mFRm_chk_t, checksum));
    if (!write_exact(input_path, original, SAVE_T_SIZE_EXPECTED) ||
        !run_codec_process(executable, "--from-be", input_path, little_endian_path) ||
        !read_exact(little_endian_path, little_endian, SAVE_T_SIZE_EXPECTED)) {
        fprintf(stderr, "canonical BE->LE child process failed\n");
        goto cleanup;
    }
    memcpy(&scene_value, little_endian + offsetof(Save_t, scene_no), sizeof(scene_value));
    memcpy(&copy_protect_value, little_endian + offsetof(Save_t, copy_protect), sizeof(copy_protect_value));
    if (scene_value != UINT32_C(0x11223344) || copy_protect_value != UINT16_C(0xA1B2)) {
        fprintf(stderr, "known scalar endian conversion failed\n");
        goto cleanup;
    }
    if (!check_opaque_ranges(original, little_endian)) {
        goto cleanup;
    }

    if (!run_codec_process(executable, "--to-be", little_endian_path, roundtrip_path) ||
        !read_exact(roundtrip_path, roundtripped, SAVE_T_SIZE_EXPECTED)) {
        fprintf(stderr, "canonical LE->BE child process failed\n");
        goto cleanup;
    }
    if (memcmp(original, roundtripped, SAVE_T_SIZE_EXPECTED) != 0) {
        size_t mismatch_count = 0;
        size_t i;

        for (i = 0; i < SAVE_T_SIZE_EXPECTED; i++) {
            if (original[i] != roundtripped[i]) {
                if (mismatch_count < 24) {
                    fprintf(stderr, "  mismatch[0x%05zX]: expected=0x%02X got=0x%02X\n",
                            i, original[i], roundtripped[i]);
                }
                mismatch_count++;
            }
        }
        fprintf(stderr, "  total mismatches: %zu\n", mismatch_count);
        fprintf(stderr, "process-restart byte roundtrip changed Save_t bytes\n");
        goto cleanup;
    }

    printf("save_gci_geometry: PASS header=0x%X data=0x%X main=0x%X backup=0x%X total=0x%X\n",
           GCI_HEADER_SIZE_EXPECTED, GCI_DATA_SIZE_EXPECTED, GCI_MAIN_OFFSET_EXPECTED,
           GCI_BACK_OFFSET_EXPECTED, GCI_TOTAL_SIZE_EXPECTED);
    printf("save_gci_checksum: PASS vector=0xFFFD full_save=0x%04X\n", checksum);
    printf("save_gci_endian_unknown_bytes: PASS scene=0x%08X copy_protect=0x%04X opaque_ranges=%zu\n",
           scene_value, copy_protect_value,
           sizeof(k_opaque_ranges) / sizeof(k_opaque_ranges[0]));
    printf("save_gci_process_restart_roundtrip: PASS bytes=0x%X\n", SAVE_T_SIZE_EXPECTED);
    result = 0;

cleanup:
    unlink(input_path);
    unlink(little_endian_path);
    unlink(roundtrip_path);
    free(original);
    free(little_endian);
    free(roundtripped);
    return result;
}

int main(int argc, char** argv) {
    if (argc == 4 && (strcmp(argv[1], "--from-be") == 0 || strcmp(argv[1], "--to-be") == 0)) {
        return run_child(argv[1], argv[2], argv[3]);
    }
    if (argc != 2) {
        fprintf(stderr, "usage: test_save_gci_codec TEST_DIRECTORY\n");
        return 2;
    }
    return run_parent(argv[0], argv[1]);
}
