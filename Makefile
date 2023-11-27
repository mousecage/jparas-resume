RESUME_BUILD_IMAGE_NAME = resume-builder
OUT_DIR = "./out"
WORKDIR = /resume
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(abspath $(patsubst %/,%,$(dir $(mkfile_path))))
MOUNT = "$(abspath $(patsubst %/,%,$(dir $(mkfile_path)))):/resume"
MYID = "$(shell id -u ${USER}):$(shell id -g ${USER})"
all: build-image clean createOut generate-resume-short-pdf-SE generate-resume-short-pdf-SRE

build-image:
	if [[ "$(docker images -q ${RESUME_BUILD_IMAGE_NAME}:latest 2> /dev/null)" == "" ]]; then \
		docker build -t $(RESUME_BUILD_IMAGE_NAME):latest .; \
	fi 
	
clean:
	rm -rf ./$(OUT_DIR)

createOut:
	mkdir -p $(OUT_DIR)

generate-resume-short-pdf-SE: build-image createOut 
	docker run --rm -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=/tmp jparas-se-resume.tex; cp /tmp/*.pdf ./out/"

generate-resume-short-pdf-SE-debug: build-image createOut 
	docker run --rm -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=${OUT_DIR} jparas-se-resume.tex;"

generate-resume-short-pdf-SRE: build-image createOut 
	docker run --rm -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=${OUT_DIR} jparas-sre-resume.tex; cp /tmp/*.pdf ./out/" 

generate-resume-short-pdf-SRE-debug: build-image createOut 
	docker run --rm -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=/tmp jparas-sre-resume.tex;"

#TODO: Do this next
#generate-resume-short-pdf-SRE: build-image createOut 
#	docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
#		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=${OUT_DIR} jparas-cs-engineer-resume.tex; cd out; find . -type f ! -name '*.pdf' -delete"
#
#generate-resume-short-pdf-SRE-debug: build-image createOut 
#	docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
#		/bin/bash -c "pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory=${OUT_DIR} jparas-cs-engineer-resume.tex;"




#generate-resume-long-pdf:
#	docker run --rm -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
#		/bin/bash -c "resume export $(OUT_DIR)/resume-long.pdf --format pdf --theme long"
#

# This is unlikely to ever be needed but might as well make one incase it is ever requested. 
#generate-cv-pdf:
#	docker run --rm -v $(MOUNT) -w $(WORKDIR) $(RESUME_BUILD_IMAGE_NAME):latest \
#		/bin/bash -c "resume export $(OUT_DIR)/cv.pdf --format pdf --theme cv"
