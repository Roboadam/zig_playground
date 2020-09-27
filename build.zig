const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("hello", "hello.zig");
    exe.setBuildMode(b.standardReleaseOptions());
    exe.addIncludeDir("C:\\Users\\adam\\dev\\glfw\\glfw-3.3.2\\include");
    exe.addLibPath("C:\\Users\\adam\\dev\\glfw\\glfw-3.3.2\\build\\src\\Release");

    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("glfw3");
    b.default_step.dependOn(&exe.step);
}
