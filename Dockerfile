FROM ubuntu

LABEL maintainer="Jeffrey J. Paras"

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

RUN apt-get install -y texlive-latex-base texlive-fonts-recommended \
    texlive-fonts-extra texlive-latex-extra biber

USER 1000