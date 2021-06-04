FROM ubuntu:18.04
RUN echo "alias l='ls -al'" >> /root/.bashrc
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y \
	&& apt install apt-utils -y  \
	&& apt install tzdata -y \
	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	&& apt install wget -y \
	&& apt install vim -y \
	&& apt install curl -y \
	&& apt install jq -y \
	&& apt install software-properties-common -y \
	&& add-apt-repository -y ppa:deadsnakes/ppa \
	&& apt install python3.6 -y \
	&& apt install python3-pip -y \
	&& pip3 install requests  \
	&& pip3 install kafka-python \
	&& apt install python-snappy -y \
	&& apt install libsnappy-dev -y \
	&& pip3 install python-snappy \
	&& pip3 install ezdxf \
	&& pip3 install shapely \
	&& pip3 install lxml \
	&& pip3 install bs4 \
	&& pip3 install html5lib \
	&& pip3 install requests \
	&& pip3 install pandas \
	&& pip3 install django


ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y install tzdata \
	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& dpkg-reconfigure --frontend noninteractive tzdata






