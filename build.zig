const std = @import("std");
const Builder = std.build.Builder;

const BuildConfig = struct {
    glfw_include_dir: []u8,
    glfw_lib_dir: []u8,
    vulkan_include_dir: []u8,
    vulkan_lib: []u8,
};

pub fn build(b: *Builder) !void {
    const exe = b.addExecutable("hello", "hello.zig");
    exe.setBuildMode(b.standardReleaseOptions());

    var build_config = try read_build_config();
    exe.addIncludeDir(build_config.glfw_include_dir);
    exe.addIncludeDir(build_config.vulkan_include_dir);
    exe.addLibPath(build_config.glfw_lib_dir);

    exe.linkSystemLibrary("glfw3");
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary(build_config.vulkan_lib);
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("shell32");
    b.default_step.dependOn(&exe.step);
    exe.install();
}

fn read_build_config() !BuildConfig {
    const allocator = std.heap.page_allocator;
    const json_file: std.fs.File = try std.fs.cwd().openFile("build_config.json", .{});
    const json_content = try readFileAlloc(allocator, json_file);
    defer json_file.close();
    defer allocator.free(json_content);

    var stream = std.json.TokenStream.init(json_content);
    return try std.json.parse(BuildConfig, &stream, .{ .allocator = allocator });
}

fn free_build_config(build_config: BuildConfig) void {
    std.json.parseFree(BuildConfig, build_config, .{ .allocator = all });
}

fn readFileAlloc(allocator: *std.mem.Allocator, file: std.fs.File) ![]u8 {
    const size = (try file.stat()).size;
    var buffer = try allocator.alloc(u8, size);

    _ = try file.readAll(buffer);

    return buffer;
}
