FROM ubuntu:latest

# Install necessary tools
RUN apt-get update
RUN apt-get install -y wget tar bzip2 cmake make gcc g++ unzip socat

# Set SDK location in the container
ENV AMEBAPRO2_SDK=/opt/amebapro2_sdk
WORKDIR ${AMEBAPRO2_SDK}

# Create build directory
RUN mkdir -p ${AMEBAPRO2_SDK}/project/realtek_amebapro2_v0_example/GCC-RELEASE/build

# Copy project files
COPY tools/ tools

# Extract the toolchain
RUN cd tools && \
    cat asdk-10.3.0-linux-newlib-build-3633-x86_64.tar.bz2.* | tar jxvf - && \
    rm asdk-10.3.0-linux-newlib-build-3633-x86_64.tar.bz2.*

RUN cd tools && \
    unzip "Pro2_PG_tool_v1.3.0.zip" && \
    rm "Pro2_PG_tool_v1.3.0.zip" && \
    chmod +x Pro2_PG_tool\ _v1.3.0/uartfwburn.linux

COPY project/ project
COPY component/ component
COPY Makefile Makefile

# Set PATH environment variable - More forceful way, prepending and setting explicitly
ENV PATH=${AMEBAPRO2_SDK}/tools/asdk-10.3.0/linux/newlib/bin:${PATH}
ENV PATH=${AMEBAPRO2_SDK}/tools/Pro2_PG_tool\ _v1.3.0:${PATH}
