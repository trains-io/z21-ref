# Headless Z21 LAN test server built from ZIMO-Elektronik/Z21 (Z21Posix example).
# https://github.com/ZIMO-Elektronik/Z21

ARG Z21_VERSION=v0.4.0

FROM ubuntu:24.04 AS builder
ARG Z21_VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      cmake \
      g++-14 \
      gcc-14 \
      git \
      ninja-build \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone --depth 1 --branch "${Z21_VERSION}" \
      https://github.com/ZIMO-Elektronik/Z21.git .

# Z21Posix is headless; skip the Qt simulator (Release configures Qt from source).
RUN sed -i '/add_subdirectory(sim)/d' examples/CMakeLists.txt

RUN CC=gcc-14 CXX=g++-14 \
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Debug && \
    cmake --build build --target Z21Posix

FROM ubuntu:24.04
COPY --from=builder /src/build/examples/posix/Z21Posix /usr/local/bin/z21-sim

EXPOSE 21105/udp

# Line-buffer stdout/stderr so `docker logs -f` shows packets as they arrive (no TTY).
ENTRYPOINT ["stdbuf", "-oL", "-eL", "/usr/local/bin/z21-sim"]
