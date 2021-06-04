#!/bin/bash
echo loader.sh start on `date`
SITE=--0
BASEDIR=/var/gdca/crontab
WORKDIR=/g2/jcbox

for((;$# > 0;)); do
	arg=$1
	shift
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

pushd $WORKDIR

dcode=`date +%F_%02H`
listname=$BASEDIR/$dcode.lst
if [ ! -e $listname ]; then
	echo $listname does not exists, nothing to do!
	popd
	exit
fi
cat $listname
logdir=$BASEDIR/log
mkdir -p $logdir
bash -x jcbox.sh $SITE --LoadList=$listname loader >$logdir/$dcode.op.log 2>$logdir/$dcode.err.log
popd
exit
