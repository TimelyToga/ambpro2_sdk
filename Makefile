IMAGE_NAME=ambpro2_build
CONTAINER_BUILD_DIR=/opt/amebapro2_sdk/project/realtek_amebapro2_v0_example/GCC-RELEASE/build
# OUTPUT_DIR=$(PWD)/fw_build
TOOL_DIR=$(PWD)/tools
TTY_DEV=/dev/cu.usbserial-2140
INTERNAL_TTY_DEV=/dev/tty99

setup:
	cd $(TOOL_DIR) && \
		cat "Pro2_PG_tool _v1.3.0.zip" | tar jxvf -

dbuild:
	docker build --platform linux/amd64 -t $(IMAGE_NAME) .

drun:
	docker run --rm -it --privileged \
		--platform linux/amd64 \
		--user $(id -u):$(id -g) \
		--device=$(TTY_DEV):$(TTY_DEV) \
		--group-add dialout \
		--cap-add=SYS_ADMIN \
		--cap-add=SYS_RAWIO \
		$(IMAGE_NAME) bash

build:
	cd $(CONTAINER_BUILD_DIR) && \
		cmake .. -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake -DVIDEO_EXAMPLE=ON && \
		cmake --build . --target flash_nn

flash:
	uartfwburn.linux -p $(INTERNAL_TTY_DEV) $(CONTAINER_BUILD_DIR)/flash_ntz.nn.bin -b 2000000 -U

clean:
	rm -rf $(OUTPUT_DIR)
