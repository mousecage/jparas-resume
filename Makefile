RESUME_BUILD_IMAGE_NAME = resume-builder
OUT_DIR = "./out"
WORKDIR = /resume
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(abspath $(patsubst %/,%,$(dir $(mkfile_path))))
MOUNT = "$(abspath $(patsubst %/,%,$(dir $(mkfile_path)))):/resume"

MYID := "-u $(shell id -u ${USER}):$(shell id -g ${USER})"
OS := $(shell uname)

ifeq ($(OS), Darwin)
MYID=""
endif

#Expanded variable
DOCKER_IMAGE_ID := $(shell docker images -q $(RESUME_BUILD_IMAGE_NAME):latest 2> /dev/null)

all: build-image clean createOut generate-resume-short-pdf-SE generate-resume-short-pdf-SRE

build-image:
ifeq (${DOCKER_IMAGE_ID},)
	docker build -t $(RESUME_BUILD_IMAGE_NAME):latest .
endif
	
clean:
	rm -rf ./$(OUT_DIR)

createOut:
	mkdir -p $(OUT_DIR)

generate-resume-short-pdf-SE: build-image createOut 
	docker run --rm ${MYID} -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=/tmp jparas-se-resume.tex; cp /tmp/*.pdf ./out/"

generate-resume-short-pdf-SE-debug: build-image createOut 
	docker run --rm ${MYID} -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=${OUT_DIR} jparas-se-resume.tex;"

generate-resume-short-pdf-SRE: build-image createOut 
	docker run --rm ${MYID} -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=/tmp jparas-sre-resume.tex; cp /tmp/*.pdf ./out/" 

generate-resume-short-pdf-SRE-debug: build-image createOut 
	docker run --rm ${MYID} -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=${OUT_DIR} jparas-sre-resume.tex;"

mkproper: clean
	docker image rm $(RESUME_BUILD_IMAGE_NAME):latest
