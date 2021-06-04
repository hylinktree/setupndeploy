#
# Dockerfile for Nginx/Etcd
#
#  docker run --name <name> --restart always -p <port>:443 -p <port>:22 -d <image>
# e.g.
# 	docker run --name mynginx --restart always -p 80:80 -d <image>
#
FROM gdca/baseng

COPY ng.default /etc/nginx/sites-available/default
COPY entry.sh /
CMD /entry.sh

