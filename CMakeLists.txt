cmake_minimum_required(VERSION 3.7)
project(isochrone_map)

include(ExternalProject)
ExternalProject_Add(libosmscout
        GIT_REPOSITORY git://git.code.sf.net/p/libosmscout/code
        INSTALL_COMMAND ""
        )

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp)
add_executable(isochrone_map ${SOURCE_FILES})
add_dependencies(isochrone_map libosmscout)