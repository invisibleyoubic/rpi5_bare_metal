export fn kmain() noreturn {
    const uart_base = 0x1c00030000;

    const UART0_DR = @as(*volatile u32, @ptrFromInt(uart_base + 0x00));

    while (true) {
        UART0_DR.* = 'A';

        var i: u32 = 0;
        while (i < 10_000_000) : (i += 1) {
            std.mem.doNotOptimizeAway(i);
        }
    }
}

const std = @import("std");
pub fn panic(_: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    while (true) {
        asm volatile ("wfi");
    }
}
