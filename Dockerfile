# Build stage
FROM ubuntu:22.04 AS build

# Avoid tzdata asking for geographic area
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary build dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    libboost-all-dev \
    libcpprest-dev \
    cmake \
    make

# Copy the source files
COPY src /app/src
COPY CMakeLists.txt /app

# Set the working directory
WORKDIR /app

# Build the C++ program
RUN cmake . && make

# Runtime stage
FROM ubuntu:22.04

# Avoid tzdata asking for geographic area
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    libboost-system1.74.0 \
    libboost-program-options1.74.0 \
    libcpprest2.10

# Copy the built server binary from the build stage
COPY --from=build /app/rest_server /app/rest_server

# Set the working directory
WORKDIR /app

# Expose the port that the server listens on
EXPOSE 8080

# Start the server
CMD ["./rest_server"]
