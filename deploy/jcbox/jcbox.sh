#!/bin/bash
if [ $# == 0 ]; then
	exit
fi
xmx="-Xmx264m"
cmd=scanner
#opts="--etcd=http://gdca.io:3721/config"
opts=
CONFIG_URL=http://gdca.io:3721/config
ETCD_URL=http://gdca.io:3721/etcd
BROKER_URL=gdca.io:3927
RACC="BigEDA@bigsftp"
RBASE="/home/BigEDA/gdca/g2"
RHOST="${RACC}:${RBASE}"
RUPLOADS="${RACC}:/home/BigEDA/gdca/uploads"

slf4jopt=
for((;$#>0;)); do
	arg=$1
	shift 
	if [ $arg == --1 ]; then
		SITE=--1
		CONFIG_URL=http://10.10.28.89:3721/config
		ETCD_URL=http://10.10.28.89:3721/etcd
		BROKER_URL=10.10.28.89:3927
		continue
	fi
	if [ $arg == --2 ]; then
		SITE=--2
		CONFIG_URL=http://10.10.28.91:3721/config
		ETCD_URL=http://10.10.28.91:3721/etcd
		BROKER_URL=10.10.28.91:3927
		continue
	fi
	if [ ${arg:0:6} == -debug ]; then
		slf4jopt=-Dorg.slf4j.simpleLogger.defaultLogLevel=${arg:7}
		continue
	fi
	if [ ${arg} == --dwg ]; then
		opts="--etcd=http://gdca.io:3721/config.dwg"
		continue
	fi
	if [ ${arg} == --rebuild ] ;then
		pushd `dirname $0`
		scp -r ${RUPLOADS}/jcbox/jcbox.jar .
		bash mk.sh $SITE
		popd
		exit
	fi

	if [ ${arg:0:2} == -- ]; then
		opts="$opts $arg"
		continue
	fi
	if [ $arg == scanner ]; then
		#opts="$opts --mingw"
		continue
	else
		cmd=$arg
		continue
	fi
done

pushd `dirname $0`
java ${xmx} ${slf4jopt} -jar jcbox.jar --etcd=${CONFIG_URL} $opts $cmd 
popd

