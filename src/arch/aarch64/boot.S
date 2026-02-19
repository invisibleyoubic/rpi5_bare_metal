.section ".text.boot"
.global _start

_start:
    mrs     x0, mpidr_el1
    and     x0, x0, #0x3
    cbz     x0, _setup_stack

_halt:
    wfe
    b       _halt

_setup_stack:
    adrp    x0, _start
    add     x0, x0, :lo12:_start
    mov     sp, x0

    adrp    x0, __bss_start
    add     x0, x0, :lo12:__bss_start
    adrp    x1, __bss_end
    add     x1, x1, :lo12:__bss_end

_bss_loop:
    cmp     x0, x1
    b.ge    _jump_zig
    str     xzr, [x0], #8
    b       _bss_loop

_jump_zig:
    bl      kmain
    b       _halt