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

# triangle
set(HELLO_TRIANGLES
    hello_triangle
    hello_triangle_index
    hello_triangle_exercise1
    hello_triangle_exercise2
    hello_triangle_exercise3
    )

foreach(TRIANGLE ${HELLO_TRIANGLES})
    add_executable(${TRIANGLE} src/hello_triangle/${TRIANGLE}.cpp ${GLAD})
endforeach()

# shaders
set(SHADER_TARGETS
    shaders
    shaders_uniform
    shaders_interpolation
    shader_class
    )
foreach(TARGET ${SHADER_TARGETS})
    add_executable(${TARGET} src/shaders/${TARGET}.cpp ${GLAD})
endforeach()

#==============
set(EXAMPLES
    hello_window
    ${HELLO_TRIANGLES}
    ${SHADER_TARGETS}
    )

foreach(EXAMPLE ${EXAMPLES})
    message("Targt -- ${EXAMPLE}")
    target_link_libraries(${EXAMPLE} glfw)
endforeach()
