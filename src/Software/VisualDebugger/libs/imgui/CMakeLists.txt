# CMakeLists.txt for Dear ImGui
cmake_minimum_required(VERSION 3.10)

# Set the Dear ImGui source directory
set(IMGUI_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# Collect source files for Dear ImGui
file(GLOB IMGUI_SOURCES
    ${IMGUI_DIR}/*.cpp
    ${IMGUI_DIR}/backends/imgui_impl_glfw.cpp
    ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
)

# Create a static library for Dear ImGui
add_library(ImGui STATIC ${IMGUI_SOURCES})

# Include directories for Dear ImGui
target_include_directories(ImGui PUBLIC
    ${IMGUI_DIR}
    ${IMGUI_DIR}/backends
)

# Link necessary libraries (GLFW and OpenGL) to ImGui
find_package(OpenGL REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(GLFW REQUIRED glfw3)

target_link_libraries(ImGui
    ${GLFW_LIBRARIES}
    OpenGL
)
