const print = @import("std").debug.print;
const c = @cImport({
    @cDefine("GLFW_INCLUDE_VULKAN", {});
    @cInclude("GLFW/glfw3.h");
});

const WIDTH: u32 = 800;
const HEIGHT: u32 = 600;

pub fn main() !void {
    var app = HelloTriangleApplication{
        .window = null,
        .instance = undefined,
    };
    try app.run();
}

const HelloTriangleApplication = struct {
    window: ?*c.GLFWwindow,
    instance: c.VkInstance,

    pub fn run(self: *HelloTriangleApplication) !void {
        self.initWindow();
        try self.initVulkan();
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

    fn initVulkan(self: *HelloTriangleApplication) !void {
        try self.createInstance();
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

    fn createInstance(self: *HelloTriangleApplication) !void {
        // This data is technically optional, but it may provide some useful
        // information to the driver in order to optimize our specific
        // application (e.g. because it uses a well-known graphics engine with
        // certain special behavior).
        const appInfo = c.VkApplicationInfo{
            .sType = c.VkStructureType.VK_STRUCTURE_TYPE_APPLICATION_INFO,
            .pApplicationName = "Hello Triangle",
            .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
            .pEngineName = "No Engine",
            .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
            .apiVersion = c.VK_API_VERSION_1_0,
            .pNext = null,
        };

        // This next struct is not optional and tells the Vulkan driver which
        // global extensions and validation layers we want to use. Global here
        // means that they apply to the entire program and not a specific
        // device. The first two parameters are straightforward. The next two
        // layers specify the desired global extensions. As mentioned in the
        // overview chapter, Vulkan is a platform agnostic API, which means
        // that you need an extension to interface with the window system. GLFW
        // has a handy built-in function that returns the extension(s) it needs
        // to do that which we can pass to the struct
        var glfwExtensionCount: u32 = 0;
        var glfwExtensions = c.glfwGetRequiredInstanceExtensions(&glfwExtensionCount);
        const createInfo = c.VkInstanceCreateInfo{
            .sType = c.VkStructureType.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
            .pApplicationInfo = &appInfo,
            .enabledExtensionCount = glfwExtensionCount,
            .ppEnabledExtensionNames = glfwExtensions,
            .enabledLayerCount = 0,
            .pNext = null,
            .flags = 0,
            .ppEnabledLayerNames = null,
        };

        if (c.vkCreateInstance(&createInfo, null, &self.instance) != c.VkResult.VK_SUCCESS) {
            return error.UnableToCreateVulkanInstance;
        }

        var extensionCount: u32 = 0;
        _ = c.vkEnumerateInstanceExtensionProperties(null, &extensionCount, null);
        var extensions: [extensionCount]c.VkExtensionProperties = undefined; // I need an allocator here
        _ = c.vkEnumerateInstanceExtensionProperties(null, &extensionCount, extensions);
        print("available extensions:\n", .{});

        for (extensions) |extension| {
            print("\t{}\n", .{extension.extensionName});
        }
    }
};
