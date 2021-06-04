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

#
# configure for etcd
#
ENV RELEASE "3.3.13"
ADD etcd-v${RELEASE}-linux-amd64.tar.gz /
RUN cd etcd-v${RELEASE}-linux-amd64 \
	&& mv etcd etcdctl /usr/local/bin  \
	&& mkdir -p /var/lib/etcd/  \
	&& mkdir /etc/etcd  \
	&& mkdir /etc/nginx/ssl \
	&& groupadd --system etcd  \
	&& useradd -s /sbin/nologin --system -g etcd etcd  \
	&& chown -R etcd:etcd /var/lib/etcd/ 
	
COPY ng.default /etc/nginx/sites-available/default
COPY entry.sh /
CMD /entry.sh

