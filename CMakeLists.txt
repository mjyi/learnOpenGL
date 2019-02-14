cmake_minimum_required(VERSION 3.10)
project(Learn_OpenGL)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build (Debug or Release)" FORCE)
ENDIF(NOT CMAKE_BUILD_TYPE)


set(CMAKE_CXX_STANDARD 14)

include_directories( include )
include_directories(deps/glad/include deps/glm)

# config glfw
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

# config glm
set(GLM_TEST_ENABLE OFF CACHE BOOL "" FORCE)

add_subdirectory(deps/glfw-3.2.1)
add_subdirectory(deps/glm)

set(LIBS glfw glm)

add_library(GLAD "deps/glad/src/glad.c")
set(LIBS ${LIBS} GLAD)


#########

set(DEMOS 
    1.0hello_window
    2.0hello_triangle
    2.1hello_triangle_index             
    2.2hello_triangle_exercise1
    2.3hello_triangle_exercise2
    2.4hello_triangle_exercise3
    3.0shaders
    3.1shaders_uniform
    3.2shaders_interpolation                 
    3.3shader_class
    4.textures                  
    )

configure_file(configuration/root_directory.h.in configuration/root_directory.h)
include_directories(${CMAKE_BINARY_DIR}/configuration)


macro(makeLink src dest target)
  add_custom_command(TARGET ${target} POST_BUILD COMMAND ${CMAKE_COMMAND} -E create_symlink ${src} ${dest}  DEPENDS  ${dest} COMMENT "mklink ${src} -> ${dest}")
endmacro()

foreach(DEMO ${DEMOS})
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
    if(WIN32)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/")
    elseif(UNIX AND NOT APPLE)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/")
    elseif(APPLE)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_CURRENT_BINARY_DIR}/bin/")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_BINARY_DIR}/bin/")
    endif(WIN32)

    # copy shader files to build directory
        file(GLOB SHADERS
                 "src/${DEMO}/*.vs"
                 "src/${DEMO}/*.fs"
                 "src/${DEMO}/*.gs"
        )
    foreach(SHADER ${SHADERS})
        if(WIN32)
            # configure_file(${SHADER} "test")
            add_custom_command(TARGET ${NAME} PRE_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${SHADER} $<TARGET_FILE_DIR:${NAME}>)
        elseif(UNIX AND NOT APPLE)
            file(COPY ${SHADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/bin/)
        elseif(APPLE)
            # create symbolic link for *.vs *.fs *.gs
            get_filename_component(SHADERNAME ${SHADER} NAME)
            makeLink(${SHADER} ${CMAKE_CURRENT_BINARY_DIR}/bin/${SHADERNAME} ${NAME})
        endif(WIN32)
    endforeach(SHADER)
    # if compiling for visual studio, also use configure file for each project (specifically to set up working directory)
    if(MSVC)
        configure_file(${CMAKE_SOURCE_DIR}/configuration/visualstudio.vcxproj.user.in ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.vcxproj.user @ONLY)
    endif(MSVC)
endforeach(DEMO)
