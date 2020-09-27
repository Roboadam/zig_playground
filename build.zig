const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("hello", "hello.zig");
    exe.setBuildMode(b.standardReleaseOptions());
    exe.linkSystemLibrary("c");
    b.default_step.dependOn(&exe.step);
}
