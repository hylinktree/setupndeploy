#!/bin/bash
RHOST=BigEDA@bigsftp
RBASE="~/gdca/uploads"
TARGET=jcbox

#rm -f yy
#scp ${RHOST}:${RBASE}/${TARGET}/start yy
#if [ -f yy ]; then
#	scp	${RHOST}:${RBASE}/${TARGET}/${TARGET}.jar .
#	ssh ${RHOST} "rm ${RBASE}/${TARGET}/start"
#fi

docker build . --no-cache -t gdca/${TARGET}

