#!/bin/bash
TARGET=relmerger

if [[ $# > 0 && $1 == --1 ]]; then
	echo nothing for site1
elif [[ $# > 0 && $1 == --2 ]]; then
	echo nothing for site2
fi
tar zcvf ${TARGET}.tgz ${TARGET}
docker build . --no-cache -t gdca/${TARGET}

