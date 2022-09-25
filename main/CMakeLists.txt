idf_component_register(SRCS "main.c"
                    INCLUDE_DIRS "nimcache")

target_compile_options(${COMPONENT_LIB} PRIVATE "-Wno-format")

add_library(libnim STATIC IMPORTED)
set_property(TARGET libnim PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/libnim.a)
target_link_libraries(${COMPONENT_LIB} PUBLIC libnim)
