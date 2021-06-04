#!/bin/bash
DATES=( 201912 202001 202002 202003 )
TYPES=( ICOS OS DXF ) # RMS RELIABILITY ERA
BASEDIR=/var/gdca/stat
pushd $BASEDIR

echo GDCA Files Process Result @ `date`

for dt in "${DATES[@]}"; do
	ls $dt > yy
	echo "$dt :"
	for t in "${TYPES[@]}"; do
		fin=`cat yy | sed -n "/pass.${t}/p" | wc -l`
		others=`cat yy | sed -n "/fail.${t}/p" | wc -l`
		printf "\t$t:\n"
		printf "\t\tpass = %d\n" $fin
		printf "\t\tfail = %d\n" $others
		
	done
done

popd
