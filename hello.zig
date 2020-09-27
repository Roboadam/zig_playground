const std = @import("std");
const print = @import("std").debug.print;
const c = @cImport(@cInclude("GLFW/glfw3.h"));

const glfw = @import("glfw");

pub fn main() void {
    if (c.glfwInit() == 0) {
        print("Hello, world!\n", .{});
    }
}
