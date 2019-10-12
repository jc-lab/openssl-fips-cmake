cmake_minimum_required(VERSION 2.8)
project(openssl-fips C ASM)

set(OPENSSL_FIPS_NAME openssl-fips-2.0.16)
set(OPENSSL_FIPS_DIR ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_FIPS_NAME} PARENT_SCOPE)
set(OPENSSL_FIPS_DIR ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_FIPS_NAME})

if(MSVC)
    message(FATAL_ERROR "Windows isn't supported yet.")
else()
	add_custom_command(
			OUTPUT ${OPENSSL_FIPS_DIR}
			COMMAND tar -xf ${CMAKE_CURRENT_SOURCE_DIR}/${OPENSSL_FIPS_NAME}.tar.gz
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	)
	add_custom_target(
			${PROJECT_NAME}-unpack
			DEPENDS ${OPENSSL_FIPS_DIR}
	)
    add_custom_command(
            OUTPUT ${OPENSSL_FIPS_DIR}/crypto/opensslconf.h ${OPENSSL_FIPS_DIR}/Makefile
            COMMAND ${OPENSSL_FIPS_DIR}/config
            WORKING_DIRECTORY ${OPENSSL_FIPS_DIR}
            DEPENDS ${PROJECT_NAME}-unpack
    )
    add_custom_target(
            ${PROJECT_NAME}-config
            DEPENDS ${OPENSSL_FIPS_DIR}/crypto/opensslconf.h ${OPENSSL_FIPS_DIR}/Makefile
    )
    add_custom_command(
            OUTPUT ${OPENSSL_FIPS_DIR}/openssl.pc
            COMMAND make
			COMMAND mkdir -p bin
			COMMAND mv fips/fips_standalone_sha1 fips/fipsld bin
			COMMAND cp -rf fips lib
            WORKING_DIRECTORY ${OPENSSL_FIPS_DIR}
            DEPENDS ${PROJECT_NAME}-config
    )
    add_custom_target(
            ${PROJECT_NAME}
            DEPENDS ${OPENSSL_FIPS_DIR}/openssl.pc
    )
endif(MSVC)
