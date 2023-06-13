cmake_minimum_required(VERSION 3.10)
project(rest_server)

set(CMAKE_CXX_STANDARD 17)

# Find required packages
find_package(Boost REQUIRED COMPONENTS system program_options)
find_package(OpenSSL REQUIRED)
find_package(cpprestsdk REQUIRED)

# Add your source files
set(SOURCES
    src/server.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})
target_link_libraries(${PROJECT_NAME} PRIVATE cpprestsdk::cpprest ${Boost_LIBRARIES} OpenSSL::SSL OpenSSL::Crypto)
