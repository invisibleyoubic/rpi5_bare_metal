.section ".text.boot"
.global _start

_start:
    // move system register to general-purpose register
    // mpidr_el1 - multiprocessor affinity register
    mrs x0, mpidr_el1   // system register
    and x0, x0, #3      // last two bits (0-3)
    cbz x0, master      // if ID == 0, goto 'master'

halt:
    // wait for event
    wfe                 // sleep if ID != 0
    b   halt

master:
    ldr x0, =_start
    mov sp, x0          // copy adress of _start to stack pointer

    bl  kmain

hang:
    wfe
    b   hang