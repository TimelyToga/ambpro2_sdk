dbuild:
	# This build will work on M1 Mac
	docker build --platform linux/amd64 -t ambpro2_build .


drun:
	# This will work on M1 Mac
	docker run --platform linux/amd64 -it --rm ambpro2_build bash

