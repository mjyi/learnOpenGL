cmake_minimum_required(VERSION 3.10)
project(LearnOpenGL)

IF (NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build (Debug or Release)" FORCE)
ENDIF (NOT CMAKE_BUILD_TYPE)

set(CMAKE_CXX_STANDARD 14)

include_directories(include)
include_directories(deps/glad/include deps/glm)

# config glfw
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)


add_subdirectory(deps/glfw-3.2.1)
set(LIBS glfw)

add_library(GLAD "deps/glad/src/glad.c")
set(LIBS ${LIBS} GLAD)


#########

set(DEMOS
        1.0.hello_window
        2.0.hello_triangle
        2.1.hello_triangle_index
        2.2.hello_triangle_exercise1
        2.3.hello_triangle_exercise2
        2.4.hello_triangle_exercise3
        3.0.shaders
        3.1.shaders_uniform
        3.2.shaders_interpolation
        3.3.shader_class
        4.0.textures
        4.1.textures_combined
        4.2.textures_exercise2
        4.3.textures_exercise3
        4.4.textures_exercise4
        5.0.transformations
        5.1.transformations_exercise2
        6.0.coordinate_systems
        6.1.coordinate_systems_depth
        6.2.coordinate_systems_multiple
        7.0.camera_circle
        7.1.camera_keyboard_dt
        7.2.camera_mouse_zoom
        7.3.camera_class
        )

configure_file(configuration/root_directory.h.in configuration/root_directory.h)
include_directories(${CMAKE_BINARY_DIR}/configuration)


macro(makeLink src dest target)
    add_custom_command(TARGET ${target} POST_BUILD COMMAND ${CMAKE_COMMAND} -E create_symlink ${src} ${dest} DEPENDS ${dest} COMMENT "mklink ${src} -> ${dest}")
endmacro()

foreach (DEMO ${DEMOS})
    file(GLOB SOURCE
            "src/${DEMO}/*.h"
            "src/${DEMO}/*.cpp"
            "src/${DEMO}/*.vs"
            "src/${DEMO}/*.fs"
            "src/${DEMO}/*.gs"
            )
    set(NAME ${DEMO})
    add_executable(${NAME} ${SOURCE})
    target_link_libraries(${NAME} ${LIBS})
    if (WIN32)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/")
    elseif (UNIX AND NOT APPLE)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/")
    elseif (APPLE)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_CURRENT_BINARY_DIR}/bin/")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_BINARY_DIR}/bin/")
    endif (WIN32)

    # copy shader files to build directory
    file(GLOB SHADERS
            "src/${DEMO}/*.vs"
            "src/${DEMO}/*.fs"
            "src/${DEMO}/*.gs"
            )
    foreach (SHADER ${SHADERS})
        if (WIN32)
            # configure_file(${SHADER} "test")
            add_custom_command(TARGET ${NAME} PRE_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${SHADER} $<TARGET_FILE_DIR:${NAME}>)
        elseif (UNIX AND NOT APPLE)
            file(COPY ${SHADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/bin/)
        elseif (APPLE)
            # create symbolic link for *.vs *.fs *.gs
            get_filename_component(SHADERNAME ${SHADER} NAME)
            makeLink(${SHADER} ${CMAKE_CURRENT_BINARY_DIR}/bin/${SHADERNAME} ${NAME})
        endif (WIN32)
    endforeach (SHADER)
    # if compiling for visual studio, also use configure file for each project (specifically to set up working directory)
    if (MSVC)
        configure_file(${CMAKE_SOURCE_DIR}/configuration/visualstudio.vcxproj.user.in ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.vcxproj.user @ONLY)
    endif (MSVC)
endforeach (DEMO)
