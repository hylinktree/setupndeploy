FROM ubuntu:18.04
RUN echo "alias l='ls -al'" >> /root/.bashrc \
	&& echo "alias l='ls -al --color=never'" >> /root/.bashrc \
	&& echo "alias gf='git fetch;git pull'" >> /root/.bashrc \
	&& echo "alias gfm='gf;gm'" >> /root/.bashrc \
	&& echo "alias gm='git commit -amnocomment;git push'" >> /root/.bashrc \
	&& echo "alias gs='git status'" >> /root/.bashrc 

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
	&& apt install apt-utils -y  \
	&& apt install wget -y \
	&& apt install vim -y \
	&& apt install curl -y \
	&& apt install jq -y \
	&& apt install software-properties-common -y \
	&& add-apt-repository -y ppa:deadsnakes/ppa \
	&& apt install python3.8 -y \
	&& apt install python3-pip -y \
	&& apt install python-snappy -y \
	&& apt install libsnappy-dev -y 

RUN apt -y install tzdata \
	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	&& rm /usr/bin/python3 \
	&& ln -s /usr/bin/python3.8 /usr/bin/python3 

RUN  python3 -m pip install pip --upgrade \
	&& python3 -m pip install mlserver sklearn mlserver-sklearn requests kafka-python python-snappy ezdxf  shapely numpy pandas lxml bs4 html5lib django flask flask_restful xlrd

# RUN apt install git -y
# RUN  git config --global user.email "docker@docker.com" &&  git config --global user.name "GitName"

# RUN python3 -m pip install tensorflow
# RUN python3 -m pip install kubeflow-kale
# RUN apt-get install python3.8-dev
