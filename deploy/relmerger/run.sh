#!/bin/bash
WORKER=relmerger
IMG=gdca/${WORKER}

DETACH=-d
ENTRYCMD=
CONFIG_URL=http://gdca.io:3721/config

for((;$# > 0;)); do
	arg=$1
	shift
	if [ $arg == -it ]; then
		DETACH=-it
		ENTRYCMD=/bin/bash
		continue
	fi
	if [ $arg == --etcd ]; then
		CONFIG_URL=$1
		shift
		continue
	fi
	if [ $arg == --0 ]; then
		continue
	fi
	if [ $arg == --1 ]; then
		CONFIG_URL=http://10.10.28.89:3721/config
		continue
	fi
	if [ $arg == --2 ]; then
		CONFIG_URL=http://10.10.28.91:3721/config
		continue
	fi
	WORKER=$arg
	break
done
docker run --rm ${DETACH} -e WORKER=${WORKER} -e ETCD_URL=${CONFIG_URL} ${GDCA_DOCKER_DNS} ${GDCA_DOCKER_EXTRA} -v /var/gdca:/var/gdca ${IMG} ${ENTRYCMD}

