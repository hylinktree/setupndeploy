#
# Dockerfile for Nginx/Etcd
#
#  docker run --name <name> --restart always -p <port>:443 -p <port>:22 -d <image>
# e.g.
# 	docker run --name mynginx --restart always -p 80:80 -d <image>
#
FROM ubuntu:18.04
EXPOSE 80/TCP
EXPOSE 443/TCP

#
# base setup
#
RUN echo "alias l='ls -al'" >> /root/.bashrc
RUN apt update && apt upgrade -y  \
	&& apt install apt-utils -y \
	&& apt install wget -y \
	&& apt install vim -y \
	&& apt install curl -y \
	&& apt install jq -y \
	&& apt install iproute2 -y \
	&& apt install nginx -y \
	&& apt install openssh-server -y

RUN mkdir /etc/nginx/ssl 
	
COPY ng.default /etc/nginx/sites-available/default
COPY entry.sh /
COPY fake.* /etc/nginx/ssl/
CMD /entry.sh

