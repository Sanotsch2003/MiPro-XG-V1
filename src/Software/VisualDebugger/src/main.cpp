#include "imgui.h"
#include "imgui_impl_glfw.h"
#include "imgui_impl_opengl3.h"
#include <GLFW/glfw3.h>
#include <iostream>

// Callback for GLFW error handling
void glfw_error_callback(int error, const char* description) {
    std::cerr << "GLFW Error " << error << ": " << description << std::endl;
}

int main() {
    // Setup GLFW
    glfwSetErrorCallback(glfw_error_callback);
    if (!glfwInit())
        return -1;

    // Setup OpenGL Version and Profile
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    // Create GLFW window
    GLFWwindow* window = glfwCreateWindow(800, 600, "ImGui App", nullptr, nullptr);
    if (window == nullptr) {
        std::cerr << "Failed to create GLFW window." << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1); // Enable vsync

    // Initialize ImGui
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    ImGui::StyleColorsDark(); // Use dark style
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init("#version 330");

    // Main loop variables
    bool show_window = true;
    bool checkbox = false;
    float slider_value = 0.5f;
    int counter = 0;

    // Main loop
    while (!glfwWindowShouldClose(window)) {
        glfwPollEvents(); // Poll events

        // Start new ImGui frame
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        // Main window
        ImGui::SetNextWindowSize(ImVec2(400, 300), ImGuiCond_Once);
        ImGui::SetNextWindowPos(ImVec2(200, 150), ImGuiCond_Once);

        if (show_window) {
            ImGui::Begin("Non-Floating Window", &show_window, ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse);

            ImGui::Text("Welcome to the ImGui App!");
            ImGui::Separator();

            // Interactive widgets
            if (ImGui::Button("Click Me!")) {
                counter++;
            }
            ImGui::SameLine();
            ImGui::Text("Button clicks: %d", counter);

            ImGui::Checkbox("Enable Feature", &checkbox);

            ImGui::Text("Adjust Value:");
            ImGui::SliderFloat("##slider", &slider_value, 0.0f, 1.0f);

            ImGui::Separator();
            ImGui::Text("Current Slider Value: %.2f", slider_value);
            ImGui::Text("Feature is %s", checkbox ? "Enabled" : "Disabled");

            ImGui::End();
        }

        // Rendering
        ImGui::Render();
        int display_w, display_h;
        glfwGetFramebufferSize(window, &display_w, &display_h);
        glViewport(0, 0, display_w, display_h);
        glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
        glfwSwapBuffers(window);
    }

    // Cleanup
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();
    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}
