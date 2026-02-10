#!/usr/bin/env bash

set -e

mkdir -p build/

zig build-exe \
    src/boot/asm/boot.S \
    src/main.zig \
    -target aarch64-freestanding-none \
    -O ReleaseSmall \
    -T src/ld/linker.ld \
    --name kernel_2712.elf \
    -fno-unwind-tables \
    -fno-stack-protector \
    -fstrip \
    -fsingle-threaded

mv kernel_2712.elf build/

zig objcopy -O binary build/kernel_2712.elf build/kernel_2712.img
du -b build/kernel_2712.img

echo "BUILT"