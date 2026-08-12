#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
iso_relative='local/roms/Animal Crossing (USA).iso'
iso_path="$repo_root/$iso_relative"
expected_iso_sha='a08ad2654831ab298071bdcdf727945efcfdd50d2b0e3512a3d361ee7b18296d'
pc_path="$repo_root/upstream/ACGC-PC-Port"
decomp_path="$repo_root/upstream/ac-decomp"
expected_pc_commit='4099d246c927e75b4fd342ca13f4ac4395c55af5'
expected_decomp_commit='09ca8e8b5b24e6ab44047ee980cf0088ad7ecb4c'
expected_static='2AE8F56E7791D37E165BD5900921F2269F9515BF  build/GAFE01_00/static.dol'
expected_rel='C59D278AD8542BB05D6CBB632F60A0DB05BEF203  build/GAFE01_00/foresta/foresta.rel'

test -f "$iso_path"
git -C "$repo_root" check-ignore -q -- "$iso_relative"
if git -C "$repo_root" ls-files --error-unmatch -- "$iso_relative" >/dev/null 2>&1; then
    printf '%s\n' 'error: local ISO is tracked by Git' >&2
    exit 1
fi

actual_iso_sha=$(shasum -a 256 "$iso_path" | awk '{print $1}')
test "$actual_iso_sha" = "$expected_iso_sha"

git -C "$pc_path" merge-base --is-ancestor "$expected_pc_commit" HEAD
test "$(git -C "$decomp_path" rev-parse HEAD)" = "$expected_decomp_commit"
test "$(git -C "$pc_path" remote get-url origin)" = 'https://github.com/flyngmt/ACGC-PC-Port.git'
test "$(git -C "$decomp_path" remote get-url origin)" = 'https://github.com/ACreTeam/ac-decomp.git'

pc_build_sha="$pc_path/config/GAFE01_00/build.sha1"
decomp_build_sha="$decomp_path/config/GAFE01_00/build.sha1"
cmp -s "$pc_build_sha" "$decomp_build_sha"
grep -Fqx "$expected_static" "$pc_build_sha"
grep -Fqx "$expected_rel" "$pc_build_sha"

test ! -e "$pc_path/.gitmodules"
test ! -e "$decomp_path/.gitmodules"

test "$(git -C "$repo_root" ls-files -s -- upstream/ACGC-PC-Port | awk '{print $2}')" = \
    "$(git -C "$pc_path" rev-parse HEAD)"
test "$(git -C "$repo_root" ls-files -s -- upstream/ac-decomp | awk '{print $2}')" = \
    "$(git -C "$decomp_path" rev-parse HEAD)"

printf '%s\n' 'GAFE01_00 source input, hashes, remotes, and submodule pins verified.'
