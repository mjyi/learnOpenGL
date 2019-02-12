cmake_minimum_required(VERSION 3.13)
project(Learn_OpenGL)

set(CMAKE_CXX_STANDARD 14)

link_directories( ${CMAKE_SOURCE_DIR}/lib )

include_directories( ${GLAD_H} )
include_directories(deps/glad/include deps/glfw-3.2.1/include)

set(GLAD_SOURCE deps/glad/src/glad.c)

if(WIN32)
    set(COMMON_LIBS glfw3 debug glfw3_d ${GLFW_LIBRARIES} ${OPENGL_LIBRARIES})
elseif (APPLE)
    set(COMMON_LIBS glfw3 )
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -framework Foundation -framework Cocoa -framework CoreGraphics -framework CoreVideo -framework IOKit" )
else()
    set(COMMON_LIBS glfw3)
endif()

add_executable(hello_window src/hello_window/main.cpp ${GLAD_SOURCE})

target_link_libraries(hello_window ${COMMON_LIBS})