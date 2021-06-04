#!/bin/bash
mkdir -p /var/gitlab/config 2>/dev/null
mkdir -p /var/gitlab/logs 2>/dev/null
mkdir -p /var/gitlab/data 2>/dev/null
docker run --detach \
  --hostname gdca.io \
  --publish 443:443 --publish 8080:80 --publish 2022:22 \
  --name mygit \
  --restart always \
  --volume /var/gitlab/config:/etc/gitlab \
  --volume /var/gitlab/logs:/var/log/gitlab \
  --volume /var/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest
  