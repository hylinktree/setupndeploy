#!/bin/bash
cd /opt/pcbox
python3 pcbox.py ${WORKER} --etcd=${ETCD_URL} >> /var/gdca/log/${WORKER}.`hostname`.err.log 2>> /var/gdca/log/${WORKER}.`hostname`.err.log
