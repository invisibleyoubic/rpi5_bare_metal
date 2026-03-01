# rpi5_bare_metal

I just want to learn bare metal Raspberry Pi 5 programming and Zig

# Some notes for myself

I'll try to maintain this document for myself

## About config.txt

I've got all parameters from the official documentation [boot_options](https://www.raspberrypi.com/documentation/computers/config_txt.html#boot-options)

There is almost no information about bare metal code for Raspberry Pi 5
My main pain was enabling GPIO pins for UART output. This minimal configuration helped me:

| option          | value           | description                                               |
|-----------------|-----------------|-----------------------------------------------------------|
| arm_64bit       | 1               | forces the CPU into AArch64 mode                          |
| kernel          | kernel_2712.img | points to the RPi 5 specific kernel binary                |
| enable_rp1_uart | 1               | prevents the firmware from resetting the RP1 UART         |
| uart_2ndstage   | 1               | enables early bootloader logging                          |
| pciex4_reset    | 0               | ensures the PCIe bus (connecting CPU to RP1) stays active |

##### Note 

On Raspberry Pi 5, the UART0 physical address might vary. You have to check uart_2ndstage logs to fetch the proper address

## Roadmap

1. [x] Implement stack pointer initialization to handle arrays, strings, and function calls
2. [x] Migrate current build script to a native build.zig
3. [ ] Implement justfile to automate building and deployment to the SD card
4. [ ] Implement a workflow to upload the kernel without physical SD-card removal:
    - Network Boot (TFTP)
    - Serial Bootloader
5. [ ] Implement a UART driver that supports reading input for a basic interactive shell
6. [ ] Implement branching logic to read and output system information
7. [ ] Implement a video driver and integrate a small display