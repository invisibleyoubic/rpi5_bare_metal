const uart_base = 0x1c00030000;
const UART0_DR = @as(*volatile u32, @ptrFromInt(uart_base + 0x00));

fn uart_print(msg: []const u8) void {
    for (msg) |char| {
        UART0_DR.* = char;
    }
}

const std = @import("std");
pub fn panic(_: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    while (true) {
        asm volatile ("wfi");
    }
}

export fn kmain() noreturn {
    var stack_msg = [_]u8{ 's', 't', 'a', 'c', 'k', '\r', '\n' };
    _ = &stack_msg;

    while (true) {
        uart_print(&stack_msg);
        uart_print("Direct message string\n\r");

        var i: u32 = 0;
        while (i < 10_000_000) : (i += 1) {
            std.mem.doNotOptimizeAway(i);
        }
    }
}
