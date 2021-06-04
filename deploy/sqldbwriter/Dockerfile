FROM gdca/basejav
RUN mkdir /opt/gdca && mkdir /var/gdca && mkdir /var/gdca/log && mkdir /var/gdca/stor 
ADD sqldbwriter.tgz /opt
CMD [ "/bin/bash", "/opt/sqldbwriter/custom.sh" ]

