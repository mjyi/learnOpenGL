cmake_minimum_required(VERSION 3.10)
project(Learn_OpenGL)

set(CMAKE_CXX_STANDARD 14)

#link_directories( ${CMAKE_SOURCE_DIR}/lib)

# config glad
include_directories(deps/glad/include)
set(GLAD_SOURCE "deps/glad/src/glad.c")

# config glfw
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

add_subdirectory(deps/glfw-3.2.1)

add_executable(hello_window src/hello_window/main.cpp ${GLAD_SOURCE})

target_link_libraries(hello_window glfw)
