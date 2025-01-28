FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && apt-get install -y wget tar bzip2 cmake make gcc g++

# Set SDK location in the container
ENV AMEBAPRO2_SDK=/opt/amebapro2_sdk
WORKDIR ${AMEBAPRO2_SDK}

# Copy project files
COPY project/ project
COPY tools/ tools
COPY component/ component

# Extract the toolchain
RUN cd tools && \
    cat asdk-10.3.0-linux-newlib-build-3633-x86_64.tar.bz2.* | tar jxvf - && \
    rm asdk-10.3.0-linux-newlib-build-3633-x86_64.tar.bz2.*

# Set PATH environment variable - More forceful way, prepending and setting explicitly
ENV PATH=${AMEBAPRO2_SDK}/tools/asdk-10.3.0/linux/newlib/bin:${PATH}

RUN cd ${AMEBAPRO2_SDK}/project/realtek_amebapro2_v0_example/GCC-RELEASE/ && \
    mkdir build && \
    cd build && \
    cmake .. -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake -DVIDEO_EXAMPLE=ON

RUN cd ${AMEBAPRO2_SDK}/project/realtek_amebapro2_v0_example/GCC-RELEASE/build && \
    cmake --build . --target flash_nn -j4