const std = @import("std");
const config = @import("config");
const drivers = @import("drivers/drivers.zig");

pub fn panic(_: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    while (true) {
        asm volatile ("wfi");
    }
}

export fn kmain() noreturn {
    const UART_BASE = if (config.is_qemu) 0x09000000 else 0x1c00030000;
    if (config.is_qemu) {
        const uart_ptr = @as(*volatile u32, @ptrFromInt(0x09000000));
        uart_ptr.* = '!';
        uart_ptr.* = '\n';
        uart_ptr.* = '\r';
    }

    var stack_msg = [_]u8{ 's', 't', 'a', 'c', 'k', '\r', '\n' };
    _ = &stack_msg;

    const uart = drivers.Uart.init(UART_BASE);

    while (true) {
        uart.print_string(&stack_msg);
        uart.print_string("Direct message string\n\r");

        uart.print_string("raw_address: ");
        uart.print_address(@as(u64, 0x1c00030000));
        uart.print_string("\n\rptr_address: ");
        uart.print_address(@as(*u32, @ptrFromInt(0x1c00030000)));
        uart.print_string("\n\r");

        uart.print_string("decimal: ");
        uart.print_dec(789456123);
        uart.print_string("\n\r");

        var i: u32 = 0;
        while (i < 10_000_000) : (i += 1) {
            std.mem.doNotOptimizeAway(i);
        }
    }
}
