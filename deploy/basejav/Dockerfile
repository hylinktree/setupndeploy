FROM ubuntu:18.04
RUN echo "alias l='ls -al'" >> /root/.bashrc
RUN apt update && apt upgrade -y && apt install apt-utils -y
RUN apt -y install wget \
	&& apt install vim -y \
	&& apt install curl -y \
	&& apt install jq -y  
#&& apt install openssh-server -y 
RUN apt update && apt upgrade -y && apt install openjdk-8-jdk -y

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y install tzdata \
	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& dpkg-reconfigure --frontend noninteractive tzdata


