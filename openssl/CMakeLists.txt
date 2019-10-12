cmake_minimum_required(VERSION 2.8)
project(openssl C ASM)

set(OPENSSL_NAME openssl-1.0.2t)
set(OPENSSL_DIR ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_NAME})

if(MSVC)
    message(FATAL_ERROR "Windows isn't supported yet.")
else()
    execute_process(
            COMMAND mkdir -p ${OPENSSL_DIR}/include
    )

    add_custom_command(
            OUTPUT ${OPENSSL_DIR}/CMakeLists.txt
            COMMAND tar -xf ${CMAKE_CURRENT_SOURCE_DIR}/${OPENSSL_NAME}.tar.gz
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    add_custom_target(
            ${PROJECT_NAME}-unpack
            DEPENDS ${OPENSSL_DIR}/CMakeLists.txt
    )
    add_custom_command(
            OUTPUT ${OPENSSL_DIR}/crypto/opensslconf.h ${OPENSSL_DIR}/Makefile.bak
            COMMAND ${OPENSSL_DIR}/config shared no-md2 no-mdc2 no-rc5 no-rc4 fips --with-fipsdir=${OPENSSL_FIPS_DIR}
            WORKING_DIRECTORY ${OPENSSL_DIR}
            DEPENDS ${PROJECT_NAME}-unpack openssl-fips
    )
    add_custom_target(
            ${PROJECT_NAME}-config
            DEPENDS ${OPENSSL_DIR}/crypto/opensslconf.h ${OPENSSL_DIR}/Makefile
    )
    add_custom_command(
            OUTPUT ${OPENSSL_DIR}/openssl.pc
            COMMAND make depend
            COMMAND make
            WORKING_DIRECTORY ${OPENSSL_DIR}
            DEPENDS ${PROJECT_NAME}-config
    )
    add_custom_target(
            ${PROJECT_NAME}
            DEPENDS ${OPENSSL_DIR}/openssl.pc
    )
endif(MSVC)

set_property(TARGET ${PROJECT_NAME} PROPERTY INCLUDE_DIR ${OPENSSL_DIR}/include)
set_property(TARGET ${PROJECT_NAME} PROPERTY LIBRARIES_DIR ${OPENSSL_DIR})
set_property(TARGET ${PROJECT_NAME} PROPERTY LIBCRYPTO_TARGET ${OPENSSL_DIR}/libcrypto.so)
set_property(TARGET ${PROJECT_NAME} PROPERTY LIBSSL_TARGET ${OPENSSL_DIR}/libssl.so)

