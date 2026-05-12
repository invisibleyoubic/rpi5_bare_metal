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
    const uart = drivers.Uart.init(UART_BASE);

    var counter: u32 = 0;
    while (true) {
        uart.print_string("Direct message string\n\r");

        uart.print_string("raw_address: ");
        uart.print_address(@as(u64, 0x1c00030000));
        uart.print_string("\n\rptr_address: ");
        uart.print_address(@as(*u32, @ptrFromInt(0x1c00030000)));
        uart.print_string("\n\r");

        uart.print_string("decimal: ");
        uart.print_dec(789456123);
        uart.print_string("\n\r");

        uart.print_string("counter: ");
        uart.print_dec(counter);
        uart.print_string("\n\r");
        counter += 1;

        var i: u32 = 0;
        while (i < 10_000_000) : (i += 1) {
            std.mem.doNotOptimizeAway(i);
        }
    }
}
