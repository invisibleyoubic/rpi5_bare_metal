#!/usr/bin/env bash

set -e

mkdir -p build/

zig build-exe \
    src/arch/aarch64/boot.S \
    src/main.zig \
    -target aarch64-freestanding-none \
    -O ReleaseSmall \
    -T src/linker.ld \
    --name kernel_2712.elf \
    -mcpu cortex_a76 \
    -fno-unwind-tables \
    -fno-stack-protector \
    -fstrip \
    -fsingle-threaded

mv kernel_2712.elf build/

zig objcopy -O binary build/kernel_2712.elf build/kernel_2712.img

echo "BUILT"