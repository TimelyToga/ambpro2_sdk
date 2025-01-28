FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && apt-get install -y wget tar bzip2 cmake make gcc g++

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

COPY project/ project
COPY component/ component
COPY Makefile Makefile

# Set PATH environment variable - More forceful way, prepending and setting explicitly
ENV PATH=${AMEBAPRO2_SDK}/tools/asdk-10.3.0/linux/newlib/bin:${PATH}

CMD ["make", "build"]