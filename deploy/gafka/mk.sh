#!/bin/bash

BROKER=$BROKER_IP
for((;$# > 0;)); do
	arg=$1
	shift
	if [ "$arg" == --0 ]; then
		continue
	fi
	if [ "$arg" == --1 ]; then
		BROKER=10.10.28.89
		continue
	fi
	if [ "$arg" == --2 ]; then
		BROKER=10.10.28.91
		continue
	fi
	cmd="$arg"
	break
done

export DOCKER_MACHINE_IP=${BROKER}
docker-compose ${cmd}


