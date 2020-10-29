const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const exe = b.addExecutable("hello", "hello.zig");
    exe.setBuildMode(b.standardReleaseOptions());
    exe.linkSystemLibrary("C:\\VulkanSDK\\1.2.154.1\\Lib\\vulkan-1");
    b.default_step.dependOn(&exe.step);
    exe.install();
}
