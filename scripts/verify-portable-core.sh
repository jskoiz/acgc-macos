#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
source_dir="$repo_root/upstream/ACGC-PC-Port/pc/portable"
build_dir="$repo_root/local/build/portable-core"

cmake -S "$source_dir" -B "$build_dir" -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build "$build_dir" --verbose
ctest --test-dir "$build_dir" --output-on-failure
