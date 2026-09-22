idf_component_register(SRCS "main.c"
                    INCLUDE_DIRS "nimcache")

target_compile_options(${COMPONENT_LIB} PRIVATE "-Wno-format")

# libnim.a is built by `nimble prepare` for one specific chip. Catch a stale library
# here, otherwise the link fails with an unhelpful "relocations in generic ELF" wall.
set(libnim_target_stamp "${CMAKE_CURRENT_SOURCE_DIR}/nimcache/.idf_target")
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${libnim_target_stamp}")
if(NOT EXISTS "${libnim_target_stamp}")
    message(FATAL_ERROR "main/libnim.a is missing or was not built by 'nimble prepare'. "
                        "Run 'nimble prepare' before building.")
endif()
file(READ "${libnim_target_stamp}" libnim_target)
string(STRIP "${libnim_target}" libnim_target)
if(NOT libnim_target STREQUAL IDF_TARGET)
    message(FATAL_ERROR "main/libnim.a was built for '${libnim_target}' but this project "
                        "targets '${IDF_TARGET}'. Re-run 'nimble prepare'.")
endif()

add_library(libnim STATIC IMPORTED)
set_property(TARGET libnim PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/libnim.a)
target_link_libraries(${COMPONENT_LIB} PUBLIC libnim)
