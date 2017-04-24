cmake_minimum_required(VERSION 2.8)
project(isochrone_map)

find_package(ZLIB)
find_package(LibLZMA)
find_package(Protobuf)
find_package(LibXml2)

include(ExternalProject)

if(NOT ${CMAKE_TOOLCHAIN_FILE} STREQUAL "")
    get_filename_component(CMAKE_TOOLCHAIN_FILE ${CMAKE_TOOLCHAIN_FILE} ABSOLUTE)
endif()


set(DEPENDS_OSM DEPENDS)

if(NOT LIBXML2_FOUND)
    if(NOT ZLIB_FOUND)
        ExternalProject_Add(zlib
                GIT_REPOSITORY https://github.com/madler/zlib
                GIT_TAG v1.2.11
                CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/zlib-prefix/install
                LOG_CONFIGURE 0
                LOG_BUILD 0
                LOG_INSTALL 0
                )
        set(XML_DEPENDS ${XML_DEPENDS} zlib)
        set(XML_CONFIGURE_FLAGS ${XML_CONFIGURE_FLAGS} --with-zlib=${CMAKE_BINARY_DIR}/zlib-prefix/install)
        set(XML_CPP_FLAGS "-I${CMAKE_BINARY_DIR}/zlib-prefix/install/include")
    endif()
    if(NOT LIBLZMA_FOUND)
        ExternalProject_Add(liblzma
                GIT_REPOSITORY https://git.tukaani.org/xz.git
                GIT_TAG v5.2.3
                BUILD_IN_SOURCE 1
                CONFIGURE_COMMAND ./autogen.sh && ./configure --host=${GNU_HOST} --prefix=${CMAKE_BINARY_DIR}/liblzma-prefix/install
                LOG_CONFIGURE 0
                LOG_BUILD 0
                LOG_INSTALL 0
                )
        set(XML_DEPENDS ${XML_DEPENDS} liblzma)
        set(XML_CONFIGURE_FLAGS ${XML_CONFIGURE_FLAGS} --with-lzma=${CMAKE_BINARY_DIR}/liblzma-prefix/install)
        set(XML_CPP_FLAGS "${XML_CPP_FLAGS} -I${CMAKE_BINARY_DIR}/liblzma-prefix/install/include")
    endif()
    configure_file("cmake/configure-libxml2.sh.in" "configure-libxml2.sh" @ONLY)
    ExternalProject_Add(libxml2
            GIT_REPOSITORY git://git.gnome.org/libxml2
            GIT_TAG v2.9.4
            BUILD_IN_SOURCE 1
            CONFIGURE_COMMAND sh ${CMAKE_CURRENT_BINARY_DIR}/configure-libxml2.sh ${XML_CPP_FLAGS} ${GNU_HOST} ${CMAKE_BINARY_DIR}/libxml2-prefix/install ${XML_CONFIGURE_FLAGS} --without-python --without-tests
            #CONFIGURE_COMMAND CPPFLAGS=-I${XML_INCLUDE} ./autogen --host=${GNU_HOST} --prefix=${CMAKE_BINARY_DIR}/libxml2-prefix/install ${XML_CONFIGURE_FLAGS}
            DEPENDS ${XML_DEPENDS}
            )
    set(OSM_DEPENDS ${OSM_DEPENDS} libxml2)

endif()

ExternalProject_Add(libosmscout
        GIT_REPOSITORY git://git.code.sf.net/p/libosmscout/code
        CMAKE_ARGS "${CMAKE_ARGS};-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE};-DOSMSCOUT_BUILD_DEMOS=OFF;-DOSMSCOUT_BUILD_TESTS=OFF;-DOSMSCOUT_BUILD_IMPORT=ON;-DOSMSCOUT_BUILD_TOOL_DUMPDATA=OFF;-DOSMSCOUT_BUILD_TOOL_IMPORT=OFF;-DOSMSCOUT_BUILD_TOOL_OSMSCOUT2=OFF;-DOSMSCOUT_BUILD_TOOL_STYLEEDITOR=OFF"
        INSTALL_COMMAND ""
        DEPENDS ${OSM_DEPENDS}
        )

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp)
add_executable(isochrone_map ${SOURCE_FILES})
add_dependencies(isochrone_map libosmscout)