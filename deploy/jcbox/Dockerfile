FROM gdca/basejav

RUN mkdir /opt/gdca && mkdir /var/gdca \
	&& mkdir /var/gdca/log && mkdir /var/gdca/stor \
	&& chmod -R 666 /var/gdca/log \
	&& chmod -R 666 /var/gdca/stor

COPY jcbox.jar /opt/gdca
COPY entry.sh  /opt/gdca
CMD /opt/gdca/entry.sh

