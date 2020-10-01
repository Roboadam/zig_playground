const print = @import("std").debug.print;
const c = @cImport({
    @cDefine("GLFW_INCLUDE_VULKAN", {});
    @cInclude("GLFW/glfw3.h");
});

pub fn main() void {
    const result = c.glfwInit();
    print("result:{} true is {}", .{ result, c.GLFW_TRUE });
    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);

    // GLFWwindow* window = glfwCreateWindow(800, 600, "Vulkan window", nullptr, nullptr);
    const window = c.glfwCreateWindow(800, 600, "Vulkan window", null, null);

    // uint32_t extensionCount = 0;
    // vkEnumerateInstanceExtensionProperties(nullptr, &extensionCount, nullptr);
    var extensionCount: u32 = 0;
    const blah = c.vkEnumerateInstanceExtensionProperties(null, &extensionCount, null);
}
