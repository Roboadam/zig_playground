const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("hello", "hello.zig");
    exe.setBuildMode(b.standardReleaseOptions());
    exe.addIncludeDir("C:\\Users\\adam\\dev\\glfw\\glfw-3.3.2\\include");
    exe.addIncludeDir("C:\\Users\\adam\\dev\\vulkan\\1.2.148.1\\Include");
    exe.addLibPath("C:\\Users\\adam\\dev\\glfw\\glfw-3.3.2\\src\\Release");

    exe.linkSystemLibrary("glfw3");
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("C:\\Users\\adam\\dev\\vulkan\\1.2.148.1\\Lib\\vulkan-1");
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("shell32");
    b.default_step.dependOn(&exe.step);
    exe.install();
}
