# HOW TO USE?

Put to your CMakeLists.txt



```cmake
set(OPENSSL_CMAKE_PATH ${CMAKE_SOURCE_DIR}/openssl-fips-cmake)
# This repository directory path

set(CMAKE_MODULE_PATH ${OPENSSL_CMAKE_PATH}/cmake)

add_subdirectory(${OPENSSL_CMAKE_PATH}/openssl-fips)
add_subdirectory(${OPENSSL_CMAKE_PATH}/openssl)

add_dependencies(YOUR_PROJECT_NAME openssl)
```



# TODO

* Windows support

