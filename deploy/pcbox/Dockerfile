FROM gdca/basepy

#ENV DEBIAN_FRONTEND=noninteractive
#RUN apt -y install tzdata \
#	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
#	&& dpkg-reconfigure --frontend noninteractive tzdata

RUN mkdir /opt/gdca && mkdir /var/gdca \
	&& mkdir /var/gdca/log && mkdir /var/gdca/stor \
	&& chmod -R 666 /var/gdca/log \
	&& chmod -R 666 /var/gdca/stor
	
ADD pcbox.tgz /opt
COPY entry.sh  /opt/gdca
CMD /opt/gdca/entry.sh 

