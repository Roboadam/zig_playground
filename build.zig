const std = @import("std");
const Builder = std.build.Builder;

const BuildConfig = struct {
    glfw_include_dir: []u8,
    glfw_lib_dir: []u8,
    vulkan_include_dir: []u8,
    vulkan_lib_dir: []u8,
};

pub fn build(b: *Builder) !void {
    const exe = b.addExecutable("hello", "hello.zig");
    exe.setBuildMode(b.standardReleaseOptions());

    const allocator = std.heap.page_allocator;
    var build_config = try alloc_and_read_build_config(allocator);
    defer free_build_config(allocator, build_config);

    exe.addIncludeDir(build_config.glfw_include_dir);
    exe.addIncludeDir(build_config.vulkan_include_dir);
    exe.addLibPath(build_config.glfw_lib_dir);
    exe.addLibPath(build_config.vulkan_lib_dir);

    exe.linkSystemLibrary("glfw3");
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("vulkan-1");
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("shell32");
    b.default_step.dependOn(&exe.step);
    exe.install();
}

fn alloc_and_read_build_config(allocator: *std.mem.Allocator) !BuildConfig {
    const json_file = try open_build_config_file();
    const json_content = try alloc_and_read_file(allocator, json_file);
    defer json_file.close();
    defer allocator.free(json_content);

    var stream = std.json.TokenStream.init(json_content);
    return try std.json.parse(BuildConfig, &stream, .{ .allocator = allocator });
}

fn free_build_config(allocator: *std.mem.Allocator, build_config: BuildConfig) void {
    std.json.parseFree(BuildConfig, build_config, .{ .allocator = allocator });
}

fn open_build_config_file() !std.fs.File {
    return std.fs.cwd().openFile("build_config.json", .{});
}

fn alloc_and_read_file(allocator: *std.mem.Allocator, file: std.fs.File) ![]u8 {
    const size = (try file.stat()).size;
    var buffer = try allocator.alloc(u8, size);
    _ = try file.readAll(buffer);
    return buffer;
}
