IMAGE_NAME=ambpro2_build
CONTAINER_BUILD_DIR=/opt/amebapro2_sdk/project/realtek_amebapro2_v0_example/GCC-RELEASE/build
OUTPUT_DIR=$(PWD)/fw_build

dbuild:
	docker build --platform linux/amd64 -t $(IMAGE_NAME) .

drun:
	@mkdir -p $(OUTPUT_DIR)
	docker run --platform linux/amd64 -it --rm -v $(OUTPUT_DIR):$(CONTAINER_BUILD_DIR) $(IMAGE_NAME)

build:
	cd $(CONTAINER_BUILD_DIR) && \
		cmake .. -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake -DVIDEO_EXAMPLE=ON && \
		cmake --build . --target flash_nn

clean:
	rm -rf $(OUTPUT_DIR)
