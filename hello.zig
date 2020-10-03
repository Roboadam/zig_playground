const print = @import("std").debug.print;
const c = @cImport({
    @cDefine("GLFW_INCLUDE_VULKAN", {});
    @cInclude("GLFW/glfw3.h");
});

const WIDTH: u32 = 800;
const HEIGHT: u32 = 600;

pub fn main() void {
    run();

    var extensionCount: u32 = 0;
    _ = c.vkEnumerateInstanceExtensionProperties(null, &extensionCount, null);

    print("{} extensions supported\n", .{extensionCount});

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glfwPollEvents();
    }

    c.glfwDestroyWindow(window);
    c.glfwTerminate();
}

const HelloTriangleApplication = struct {
    var window: f32;

    pub fn run() void {
        initWindow();
        initVulkan();
        mainLoop();
        cleanup();
    }

    fn initWindow() void {
    // Initalize the window
    _ = c.glfwInit();

    // Because GLFW was originally designed to create an OpenGL context, we
    // need to tell it to not create an OpenGL context.
    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);

    // Disable window resizing
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_FALSE);

    // Create the actual window
    window = c.glfwCreateWindow(WIDTH, HEIGHT, "Vulkan window", null, null);
    }
fn initVulkan() void {}

fn mainLoop() void {}

fn cleanup() void {}
}
