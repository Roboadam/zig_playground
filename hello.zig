const std = @import("std");
const c = @cImport(@cInclude("GLFW/glfw3.h"));

const glfw = @import("glfw");

pub fn main() void {
    if (c.glfwInit()) {
        print("Hello, world!\n", .{});
    }
}
