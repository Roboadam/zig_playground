const Builder = @import("std").build.Builder;
const fs = @import("std").fs;
const allocator = @import("std").heap.page_allocator;

const BuildConfig = struct {
    glfw_include_dir: []u8,
    glfw_lib_dir: []u8,
    vulkan_include_dir: []u8,
    vulkan_lib: []u8,
};

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("hello", "hello.zig");
    exe.setBuildMode(b.standardReleaseOptions());

    try read_build_config();
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

fn read_build_config() !void {
    const env_file: fs.File = try fs.cwd().openFile("build_config.json", .{});
    defer env_file.close();
    var buffer: [2000]u8 = undefined;
    env_file.read(buffer);

    var stream = std.json.TokenStream.init(buffer);
    try std.json.parse(BuildConfig, &stream, .{ .allocator = allocator });
}

fn free_build_config(build_config: BuildConfig) void {
    std.json.parseFree(BuildConfig, build_config, .{ .allocator = all });
}
