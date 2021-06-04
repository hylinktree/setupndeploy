#!/bin/bash
cd /opt/gdca
java -Xmx128m -jar jcbox.jar --etcd=${ETCD_URL}  ${WORKER} >>/var/gdca/log/${WORKER}.`hostname`.log 2>> /var/gdca/log/${WORKER}.`hostname`.err.log
