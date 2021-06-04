#!/bin/bash
DETACH=-d
ETCD_URL=http://gdca.io:80/config
WORKER=scanner
for((;$# > 0;)); do
	if [ $1 == -it ]; then
		shift
		DETACH=-it
		continue
	fi
	WORKER=$1
	break
done
docker run --rm ${DETACH} -e WORKER=${WORKER} -e ETCD_URL=${ETCD_URL} -v /var/gdca:/var/gdca gdca/pcbox
