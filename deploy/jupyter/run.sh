#!/bin/bash
WORKER=jupyter
IMG=hylinktree/jupyter


DETACH=-d
ENTRYCMD=
MAPPORT="-p 8888:8888"
MAPVOLUMNE="-v /mnt/jupyter:/mnt/jupyter"
RESTART="--restart always"


if [ x$1 == x ]; then
	docker stop ${WORKER} 2>/dev/null
	docker rm ${WORKER} 2>/dev/null
	DOCKER_OPTS="${DETACH} ${MAPPORT} ${MAPVOLUMNE} ${RESTART}"
	docker run --name ${WORKER} ${DOCKER_OPTS} $IMG ${ENTRYCMD}
else
	DETACH=-it
	RESTART=
	DOCKER_OPTS="${DETACH} ${MAPPORT} ${MAPVOLUMNE} ${RESTART}"
	docker run --rm ${DOCKER_OPTS} $IMG /bin/bash
fi

