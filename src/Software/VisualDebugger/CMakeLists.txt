cmake_minimum_required(VERSION 3.10)
project(SimpleUI)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include paths for headers
include_directories(
    include
    libs/imgui
    libs/imgui/backends
)

# Add Dear ImGui as a library
add_subdirectory(libs/imgui)

# Find GLFW
find_package(PkgConfig REQUIRED)
pkg_check_modules(GLFW REQUIRED glfw3)

# Add source files
set(SOURCES
    src/main.cpp
)

# Create the executable
add_executable(SimpleUI ${SOURCES})

# Link libraries
target_link_libraries(SimpleUI
    ImGui
    ${GLFW_LIBRARIES}
    OpenGL
    dl
    pthread
)

