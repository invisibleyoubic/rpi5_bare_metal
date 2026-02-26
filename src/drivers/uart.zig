pub const Uart = struct {
    // Base address
    base_addr: usize,

    // Data Register
    const DR = 0x000;

    // Receive Status Register / Error Clear Register
    const SR_CR = 0x004;

    // 0x008 - 0x014 Reserver

    // Flag Register (RO)
    const FR = 0x018;

    // 0x01C Reserver

    // IrDA Low-Power Counter Register (RW)
    const ILPR = 0x020;

    // Integer Baud Rate Register (RW)
    const IBRD = 0x024;

    // Fractional Baud Rate Register (RW)
    const FBRD = 0x028;

    // Line Control Register (RW)
    const LCR_H = 0x02C;

    // Control Register (RW)
    const CR = 0x030;

    // Interrupt FIFO Level Select Register (RW)
    const IFLS = 0x034;

    // Interrupt Mask Set/Clear Register (RW)
    const IMSC = 0x038;

    // Raw Interrupt Status Register (RO)
    const RIS = 0x03C;

    // Masked Interrupt Status Register (RO)
    const MIS = 0x040;

    // Interrupt Clear Register (WO)
    const ICR = 0x044;

    // DMA Control Register (RW)
    const DMACR = 0x048;

    // 0x04C - 0x07C Reserver

    // 0x080 - 0x08C Reserver for test purposes

    // 0x090 - 0xFCC Reserver

    // 0xFD0 - 0xFDC Reserver for future ID expansion

    // UARTPeriphID0 Register (RO)
    const PeriphID0 = 0xFE0;

    // UARTPeriphID1 Register (RO)
    const PeriphID1 = 0xFE4;

    // UARTPeriphID2 Register (RO)
    const PeriphID2 = 0xFE8;

    // UARTPeriphID3 Register (RO)
    const PeriphID3 = 0xFEC;

    // UARTPCellID0 Register (RO)
    const PCellID0 = 0xFF0;

    // UARTPCellID1 Register (RO)
    const PCellID1 = 0xFF4;

    // UARTPCellID2 Register (RO)
    const PCellID2 = 0xFF8;

    // UARTPCellID3 Register (RO)
    const PCellID3 = 0xFFC;

    pub fn init(base_addr: usize) Uart {
        return Uart{ .base_addr = base_addr };
    }

    pub inline fn print_char(self: Uart, char: u8) void {
        while (self.get_register(FR).* & (1 << 5) != 0) {}
        self.get_register(DR).* = char;
    }

    pub fn print_string(self: Uart, str: []const u8) void {
        for (str) |char| {
            self.print_char(char);
        }
    }

    fn get_register(self: Uart, offset: usize) *volatile u32 {
        return @ptrFromInt(self.base_addr + offset);
    }
};
