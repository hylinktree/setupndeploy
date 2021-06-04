#!/bin/bash
flimit=$((1024*1024*100))
flines=2000
fremains=$((1024*1024*2))

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

echo $0 runs @ `date`
pushd /g2log >/dev/null
n=`ls *.log 2>/dev/null|wc -l `
if (( $n == 0 )); then
	echo No log to purge
	popd >/dev/null
	exit
fi

basedir=.history/`date +%F_%H`
odir=
get_unique_dir odir $basedir

n=`ls *log|wc -l`
if [ $n == 0 ]; then
	popd
	exit
fi
for f in *.log ; do
	for((i=0;;i++)); do
		fsize=`stat -c%s $f`
		if (( $fsize < $flimit )); then
			break
		fi
		if (( $i == 0 )); then
			mkdir -p $odir 2>/dev/null
			tail -n${flines} $f > $odir/$f
		else
			echo !!retry.$i on $f
		fi
		truncate -s $fremains $f
		sleep 2
	done
done
popd >/dev/null
