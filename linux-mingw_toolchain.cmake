SET(CMAKE_SYSTEM_NAME Windows)

IF("${GNU_HOST}" STREQUAL "")
    SET(GNU_HOST i686-w64-mingw32)
ENDIF()

SET(CMAKE_C_COMPILER ${GNU_HOST}-gcc)
SET(CMAKE_CXX_COMPILER ${GNU_HOST}-g++)
SET(CMAKE_RC_COMPILER ${GNU_HOST}-windres)