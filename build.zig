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

    const elf = b.addExecutable(.{
        .name = "kernel_2712.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = std.builtin.OptimizeMode.ReleaseSmall,
            .single_threaded = true,
            .stack_protector = false,
            .strip = true,
            .error_tracing = false,
            .unwind_tables = .none,
            .link_libc = false,
            .link_libcpp = false,
        }),
    });

    elf.addAssemblyFile(b.path("src/arch/aarch64/boot.S"));
    elf.setLinkerScript(b.path("src/linker.ld"));
    elf.bundle_compiler_rt = false;

    const bin = elf.addObjCopy(.{ .format = .bin });

    const install_bin = b.addInstallBinFile(bin.getOutput(), "kernel_2712.img");
    b.getInstallStep().dependOn(&install_bin.step);

    b.installArtifact(elf);
}
