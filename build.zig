const Builder = @import("std").Build;
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const bin = b.addExecutable(.{
        .name = "netserver",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const libapenetwork = b.dependency("libapenetwork", .{ .target = target, .optimize = optimize });
    const apenetwork = libapenetwork.artifact("apenetwork");

    bin.linkLibrary(apenetwork);
    bin.addObjectFile(.{ .cwd_relative = "../c-ares-1.17.2/src/lib/.libs/libcares.a" });
    bin.linkSystemLibrary("z");
    bin.linkSystemLibrary("resolv");
    bin.linkLibC();

    // bin.root_module.addImport("apenetwork", libapenetwork.module("libapenetwork"));
    // bin.addObjectFile()

    b.installArtifact(bin);
}
