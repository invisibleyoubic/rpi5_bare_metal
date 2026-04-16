const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .aarch64,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{
            .explicit = &std.Target.arm.cpu.cortex_a76,
        },
    });

    const is_qemu = b.option(bool, "is_qemu", "Build for QEMU debug or RPI5") orelse false;

    const binary_name = if (is_qemu) "kernel_2712-qemu" else "kernel_2712";
    const elf_name = b.fmt("{s}.elf", .{binary_name});
    const img_name = b.fmt("{s}.img", .{binary_name});

    var options = b.addOptions();
    options.addOption(bool, "is_qemu", is_qemu);

    const elf = b.addExecutable(.{
        .name = elf_name,
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = if (is_qemu) std.builtin.OptimizeMode.Debug else std.builtin.OptimizeMode.ReleaseSmall,
            .single_threaded = true,
            .stack_protector = false,
            .strip = !is_qemu,
            .error_tracing = false,
            .unwind_tables = .none,
            .link_libc = false,
            .link_libcpp = false,
        }),
    });

    elf.addAssemblyFile(b.path("src/arch/aarch64/boot.S"));
    elf.setLinkerScript(b.path("src/linker.ld"));
    elf.bundle_compiler_rt = is_qemu;
    elf.root_module.addOptions("config", options);

    const bin = elf.addObjCopy(.{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), img_name);
    b.getInstallStep().dependOn(&install_bin.step);

    b.installArtifact(elf);
}
