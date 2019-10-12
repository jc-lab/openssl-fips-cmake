set(OPENSSL_FOUND 1)

get_target_property(OPENSSL_INCLUDE_DIR openssl INCLUDE_DIR)
get_target_property(OPENSSL_LIBCRYPTO_TARGET openssl LIBCRYPTO_TARGET)
get_target_property(OPENSSL_LIBSSL_TARGET openssl LIBSSL_TARGET)
set(OPENSSL_LIBRARIES "${OPENSSL_LIBCRYPTO_TARGET} ${OPENSSL_LIBSSL_TARGET}")

if(NOT CMAKE_VERSION VERSION_LESS 3.4)
    add_library(OpenSSL::Crypto UNKNOWN IMPORTED)
    set_target_properties(OpenSSL::Crypto PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_INCLUDE_DIR}")
    set_target_properties(OpenSSL::Crypto PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
            IMPORTED_LOCATION "${OPENSSL_LIBCRYPTO_TARGET}")

    add_library(OpenSSL::SSL UNKNOWN IMPORTED)
    set_target_properties(OpenSSL::SSL PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_INCLUDE_DIR}")
    set_target_properties(OpenSSL::SSL PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
            IMPORTED_LOCATION ${OPENSSL_LIBSSL_TARGET})
endif()

