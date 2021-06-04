#!/bin/bash
pushd `dirname $0` >/dev/null
LOGDIR=/var/gdca/journal
SITE=--0
CONFIG_URL=http://gdca.io:3721/config
ETCD_URL=http://gdca.io:3721/etcd
BROKER_URL=gdca.io:3927

nbacks=1

get_unique_dir() {
	# $1, the return 
	# $2, the base
	
	local i=1
	local rdir=$2
	for((;;i++));do
		if [ ! -d $rdir ]; then
			eval "$1=$rdir"
			break
		fi
		rdir=$2,$i
	done
}

for((;$# > 0;)); do
	arg=$1
	shift
	if [ ${arg:0:9} == --nbacks= ]; then
		nbacks=${arg:9}
		continue
	fi
	if [ $arg == --0 ]; then
		SITE=--0
		continue
	fi
	if [ $arg == --1 ]; then
		SITE=--1
		continue
	fi
	if [ $arg == --2 ]; then
		SITE=--2
		continue
	fi
done

# get current day tick
t=`date +%F`
tick=`date --date=$t +%s`
tick=$((tick - 86400*${nbacks}))

EDATE=`date --date=@${tick} +%Y%m%d`
basedir=/var/gdca/journal/`date --date=@${tick} +%F`
JDIR=
get_unique_dir JDIR $basedir

mkdir -p $JDIR
bash jcbox.sh ${SITE} --JournalDir=$JDIR --Date=${EDATE}00-24 hk >> ${LOGDIR}/hk.log 2>> ${LOGDIR}/hk.log
pushd $JDIR > /dev/null
n=`ls -l works* | wc -l`
if [[ $n > 0 ]]; then
	rm -rf yy
	for f in works* ; do
		mv $f yy
		sort yy > $f
		rm -rf yy
	done
fi
n=`ls -l files* | wc -l`
if [[ $n > 0 ]]; then
	rm -rf yy
	for f in files* ; do
		mv $f yy
		sort yy > $f
		rm -rf yy
	done
fi
popd >/dev/null
popd >/dev/null


