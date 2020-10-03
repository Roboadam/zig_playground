const print = @import("std").debug.print;
const c = @cImport({
    @cDefine("GLFW_INCLUDE_VULKAN", {});
    @cInclude("GLFW/glfw3.h");
});

const WIDTH: u32 = 800;
const HEIGHT: u32 = 600;

pub fn main() void {
    var app = HelloTriangleApplication{
        .window = null,
        .instance = null,
    };
    app.run();

    // var extensionCount: u32 = 0;
    // _ = c.vkEnumerateInstanceExtensionProperties(null, &extensionCount, null);
    // print("{} extensions supported\n", .{extensionCount});
}

const HelloTriangleApplication = struct {
    window: ?*c.GLFWwindow,
    instance: ?*c.VkInstance,

    pub fn run(self: *HelloTriangleApplication) void {
        self.initWindow();
        self.initVulkan();
        self.mainLoop();
        self.cleanup();
    }

    fn initWindow(self: *HelloTriangleApplication) void {
        // Initalize the window
        _ = c.glfwInit();

        // Because GLFW was originally designed to create an OpenGL context, we
        // need to tell it to not create an OpenGL context.
        c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);

        // Disable window resizing
        c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_FALSE);

        // Create the actual window
        self.window = c.glfwCreateWindow(WIDTH, HEIGHT, "Vulkan window", null, null);
    }

    fn initVulkan(self: HelloTriangleApplication) void {
        self.createInstance();
    }

    fn mainLoop(self: HelloTriangleApplication) void {
        while (c.glfwWindowShouldClose(self.window) == c.GLFW_FALSE) {
            c.glfwPollEvents();
        }
    }

    fn cleanup(self: HelloTriangleApplication) void {
        c.glfwDestroyWindow(self.window);
        c.glfwTerminate();
    }

    fn createInstance(self: HelloTriangleApplication) void {}
};
