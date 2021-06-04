#!/bin/bash

pushd `dirname $0` > /dev/null
RACC="BigEDA@bigsftp"
RBASE="/home/BigEDA/gdca/g2"
RHOST="${RACC}:${RBASE}"

for((;$#>0;));do
	arg=$1
	shift
	if [ $arg == --0 ]; then
		RACC="chu@gdca.io"
		RBASE="/home/chu/g2"
		RHOST="${RACC}:${RBASE}"
		continue
	fi
	if [ $arg == --9 ]; then
		RACC="kk@kkio.io"
		RBASE="/home/kk/g2"
		RHOST="${RACC}:${RBASE}"
		continue
	fi
	if [ $arg == --mkdir ]; then
		LST=( "" "tools" "basego" "basejav" "basepy" "baseka" "basezk" "baseng" "nginx" "gafka" "jcbox" "pcbox" "gcbox" "sqlscripts" "sqldbwriter" "faworker" "relmerger" "postsql" )
		for s in "${LST[@]}"; do
			ssh ${RACC} mkdir ${RBASE}/$s 2>/dev/null
		done
		continue
	fi
	if [ $arg == --setup ]; then
		LST=( "basego" "basejav" "basepy" "baseka" "basezk" "baseng" "nginx" "gafka" )
		for s in "${LST[@]}"; do
			TGT=$s
			scp -r ${TGT}/* ${RHOST}/${TGT}
		done
	fi
	break
done

scp deploy.txt ${RHOST}/deploy.sh
scp wk.sh ${RHOST}/

LST=( "tools" "pcbox" "jcbox" "sqlscripts" "sqldbwriter" "faworker" "relmerger" "postsql" )
for s in "${LST[@]}"; do
	TGT=$s
	scp -r ${TGT}/* ${RHOST}/${TGT}
done
popd > /dev/null
