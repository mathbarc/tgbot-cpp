FROM debian:latest as base

RUN apt-get -qq update &&\
    apt-get -qq install -y libcurl4 libssl3 zlib1g &&\
    rm -rf /var/lib/apt/lists/*

FROM base as builder
RUN apt-get -qq update && \
    apt-get -qq install -y g++ make binutils cmake libssl-dev libboost-system-dev libcurl4-openssl-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/tgbot-cpp
COPY include include
COPY src src
COPY CMakeLists.txt ./

RUN cmake . && \
    make -j$(nproc) && \
    make install

FROM base as runner

COPY --from=builder /usr/local /usr/local
