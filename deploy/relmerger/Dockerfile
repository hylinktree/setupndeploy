FROM gdca/basejav
RUN mkdir /opt/gdca && mkdir /var/gdca && mkdir /var/gdca/log && mkdir /var/gdca/stor 
ADD relmerger.tgz /opt
CMD [ "/bin/bash", "/opt/relmerger/custom.sh" ]

