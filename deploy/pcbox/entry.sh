#!/bin/bash
cd /opt/pcbox
export PYTHONIOENCODING=utf-8 
python3 -u pcbox.py --etcd=${ETCD_URL} ${WORKER} >> /var/gdca/log/${WORKER}.`hostname`.log 2>> /var/gdca/log/${WORKER}.`hostname`.err.log
