#!/bin/bash
# this container is supposed to created w/ the following statement
# docker run --name tulip --restart always -p 4433:443 -p 2222:22 -d hylinktree/tulip
# post to add user

BASEDIR=/etcd-data
LOGFILE=$BASEDIR/etcd.log

#useradd -m -d /home/kop kop
#/post-etcd.sh
#service ssh start
nginx
for((i=0;;i++)); do
	echo "etcd starts.$i at `date`" >> $LOGFILE
	etcd --data-dir=/etcd-data >> $LOGFILE 2>> $LOGFILE
	echo "etcd ends.$i at `date`" >> $LOGFILE
	sleep 120
done
