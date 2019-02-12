cmake_minimum_required(VERSION 3.10)
project(Learn_OpenGL)

set(CMAKE_CXX_STANDARD 14)

#link_directories( ${CMAKE_SOURCE_DIR}/lib)

# config glad
include_directories(deps/glad/include)
set(GLAD "deps/glad/src/glad.c")

# config glfw
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

add_subdirectory(deps/glfw-3.2.1)

add_executable(hello_window src/hello_window/main.cpp ${GLAD})
add_executable(hello_triangle src/hello_triangle/hello_triangle.cpp ${GLAD})
add_executable(hello_triangle_index src/hello_triangle/hello_triangle_index.cpp ${GLAD})

set(EXAMPLES
    hello_window
    hello_triangle
    hello_triangle_index
    )

foreach(EXAMPLE ${EXAMPLES})
    target_link_libraries(${EXAMPLE} glfw)
endforeach()
