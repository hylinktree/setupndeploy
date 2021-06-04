FROM gdca/basejav
RUN mkdir /opt/gdca && mkdir /var/gdca && mkdir /var/gdca/log && mkdir /var/gdca/stor 
ADD faworker.tgz /opt
CMD [ "/bin/bash", "/opt/faworker/custom.sh" ]

