const std = @import("std");
const drivers = @import("drivers/drivers.zig");

pub fn panic(_: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    while (true) {
        asm volatile ("wfi");
    }
}

export fn kmain() noreturn {
    var stack_msg = [_]u8{ 's', 't', 'a', 'c', 'k', '\r', '\n' };
    _ = &stack_msg;

    const uart = drivers.Uart.init(0x1c00030000);
    while (true) {
        uart.print_string(&stack_msg);
        uart.print_string("Direct message string\n\r");

        var i: u32 = 0;
        while (i < 10_000_000) : (i += 1) {
            std.mem.doNotOptimizeAway(i);
        }
    }
}
