#!/bin/bash
apt update && apt upgrade -y && apt install apt-utils -y
apt -y install wget && apt install vim -y && apt install curl -y && apt install jq -y

export DEBIAN_FRONTEND=noninteractive
apt -y install tzdata && ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata
