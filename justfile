mount_point:="/mnt/rpi_boot"

build jobs="4":
    zig build -j{{jobs}}
    @echo "====================="
    @echo "BUILT SUCCESSFULLY"

clean:
    rm -rf zig-out .zig-cache

disasm:
    aarch64-linux-gnu-objdump -d zig-out/bin/kernel_2712.elf

_copy-usb:
    sudo cp zig-out/bin/kernel_2712.img     {{mount_point}}/kernel_2712.img
    sudo cp artifacts/config.txt            {{mount_point}}/config.txt

upload-usb partition="":
    @test -n "{{partition}}" || (echo "ERROR: empty partition"; exit 1)
    @mkdir -p {{mount_point}}
    @sudo mount {{partition}}1 /mnt/rpi_boot
    @just _copy-usb
    @sudo sync
    @sudo umount {{partition}}1
    @echo "====================="
    @echo "UPLOADED SUCCESSFULLY"

upload-usb-full partition="":
    @test -n "{{partition}}" || (echo "ERROR: empty partition"; exit 1)
    @mkdir -p {{mount_point}}
    @sudo mount {{partition}}1 {{mount_point}}
    @just _copy-usb
    sudo cp artifacts/bcm2712-rpi-5-b.dtb   {{mount_point}}/bcm2712-rpi-5-b.dtb
    @sudo sync
    @sudo umount {{partition}}1
    @echo "====================="
    @echo "UPLOADED SUCCESSFULLY"

terminal device="/dev/ttyUSB0" speed="115200":
    sudo minicom -D {{device}} -b {{speed}}
