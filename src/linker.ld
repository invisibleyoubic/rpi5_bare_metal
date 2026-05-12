ENTRY(_start)

MEMORY
{
    ram (rwx) : ORIGIN = RAM_START, LENGTH = 512M
}

SECTIONS
{
    .text : {
        KEEP(*(.text.boot))
        *(.text .text.*)
        *(.rodata .rodata.*)
        . = ALIGN(16);
    } > ram

    .data : {
        . = ALIGN(16);
        *(.data .data.*)
    } > ram

    .bss : {
        . = ALIGN(16);
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(16);
        __bss_end = .;
    } > ram

    . = ALIGN(16);
    /*64 KB stack*/
    . += 0x10000;
    _stack_top = .;

    . = ALIGN(4096);
    _end = .;

    /DISCARD/ : { 
        *(.comment) 
        *(.gnu*) 
        *(.note*) 
        *(.eh_frame)
    }
}