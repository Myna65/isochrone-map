cmake_minimum_required(VERSION 2.8)
project(isochrone_map)

include(ExternalProject)
ExternalProject_Add(libosmscout
        GIT_REPOSITORY git://git.code.sf.net/p/libosmscout/code
        CMAKE_ARGS "${CMAKE_ARGS};-DOSMSCOUT_BUILD_DEMOS=OFF;-DOSMSCOUT_BUILD_TESTS=OFF;-DOSMSCOUT_BUILD_IMPORT=ON;-DOSMSCOUT_BUILD_TOOL_DUMPDATA=OFF;-DOSMSCOUT_BUILD_TOOL_IMPORT=OFF;-DOSMSCOUT_BUILD_TOOL_OSMSCOUT2=OFF;-DOSMSCOUT_BUILD_TOOL_STYLEEDITOR=OFF"
        INSTALL_COMMAND ""
        )

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp)
add_executable(isochrone_map ${SOURCE_FILES})
add_dependencies(isochrone_map libosmscout)