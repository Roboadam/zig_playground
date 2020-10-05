const std = @import("std");
const print = std.debug.print;
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
        c.vkDestroyInstance(self.instance, null);
        c.glfwDestroyWindow(self.window);
        c.glfwTerminate();
        print("All cleaned up!", .{});
    }

    fn createInstance(self: *HelloTriangleApplication) !void {
        // TODO: disable this in release mode
        if (!try checkValidationLayerSupport()) {
            return error.ValidationLayerNotFound;
        }

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
        // var extensions: [extensionCount]c.VkExtensionProperties = undefined; // I need an allocator here
        const allocator = std.heap.page_allocator;
        var extensions = try allocator.alloc(c.VkExtensionProperties, extensionCount);
        _ = c.vkEnumerateInstanceExtensionProperties(null, &extensionCount, extensions.ptr);
        print("available extensions:\n", .{});

        for (extensions) |extension| {
            _ = std.c.printf("\t%s\n", .{extension.extensionName});
        }
    }

    fn checkValidationLayerSupport() !bool {
        var layerCount: u32 = 0;
        _ = c.vkEnumerateInstanceLayerProperties(&layerCount, null);

        const allocator = std.heap.page_allocator;
        var availableLayers = try allocator.alloc(c.VkLayerProperties, layerCount);
        _ = c.vkEnumerateInstanceLayerProperties(&layerCount, availableLayers.ptr);

        for (validationLayers) |layerName| {
            var layerFound = false;

            for (availableLayers) |layerProperties| {
                print("layerName len:{}, fromc len:{}\n", .{ layerName.len, layerProperties.layerName.len });
                // if (std.mem.eql(u8, layerName, layerProperties.layerName)) {
                //     layerFound = true;
                //     break;
                // }
            }

            if (!layerFound) {
                return false;
            }
        }

        return true;
    }
};

const validationLayers = [_][]const u8{
    "VK_LAYER_KHRONOS_validation",
};
