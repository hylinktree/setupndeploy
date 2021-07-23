FROM golang:latest
RUN echo "alias l='ls -al'" >> /root/.bashrc
RUN apt update && apt upgrade -y && apt install apt-utils -y
RUN apt -y install wget \
	&& apt install curl -y 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y install tzdata \
	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& dpkg-reconfigure --frontend noninteractive tzdata
RUN go get -u -v github.com/go-resty/resty/v2 &&\
    go get -u -v github.com/gin-gonic/gin

