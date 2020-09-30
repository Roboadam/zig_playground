const print = @import("std").debug.print;
const c = @cImport(@cInclude("GLFW/glfw3.h"));
const glfw = @import("glfw");

pub fn main() void {
    const result = c.glfwInit();
    print("result:{} true is {}", .{ result, c.GLFW_TRUE });
}
