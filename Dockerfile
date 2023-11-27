FROM ubuntu

RUN apt-get update
RUN apt-cache search latex --names-only
RUN apt-cache search pdflatex --names-only

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata


RUN apt-get install -y texlive-latex-base texlive-fonts-recommended \
    texlive-fonts-extra texlive-latex-extra biber

#For quick testing 
COPY ./altacv.cls .
COPY ./jparas-cs-engineer-resume.tex .
COPY ./Globe_High.png .
COPY ./pubs-num.cfg .
RUN pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder jparas-cs-engineer-resume.tex
