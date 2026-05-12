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
    const ram_address = if (is_qemu) "0x40000000" else "0x80000";
    const file_write = b.addWriteFiles();
    const proxy_script = file_write.add("linker_proxy.ld", b.fmt(
        "RAM_START = {s};\nINCLUDE \"src/linker.ld\"",
        .{ram_address},
    ));

    const binary_name = if (is_qemu) "kernel_2712-qemu" else "kernel_2712";
    const elf_name = b.fmt("{s}.elf", .{binary_name});
    const img_name = b.fmt("{s}.img", .{binary_name});

    var options = b.addOptions();
    options.addOption(bool, "is_qemu", is_qemu);
    const config_module = options.createModule();

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

    elf.root_module.addOptions("config", options);
    elf.root_module.addImport("config", config_module);
    elf.root_module.addAssemblyFile(b.path("src/arch/aarch64/boot.S"));

    elf.setLinkerScript(proxy_script);
    elf.bundle_compiler_rt = is_qemu;

    const check = b.step("check", "Check if your_executable compiles");
    check.dependOn(&elf.step);

    const bin = elf.addObjCopy(.{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), img_name);
    b.getInstallStep().dependOn(&install_bin.step);

    b.installArtifact(elf);
}
