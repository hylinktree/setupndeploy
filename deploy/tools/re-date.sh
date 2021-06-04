#!/bin/bash
Ntag=20200101
Type=OS
Suffix=tar.gz
DStart=201
DEnd=229
DSpc=0

if (( $# < 5 )); then
	echo $0 Tag DStart Dend Type Suffix
	exit
fi

Type=$4
Suffix=$5
DStart=$2
DEnd=$3
Ntag=$1

if (( $DEnd > 1000 )); then
	DSpc=
fi

for((i=$DStart;i<=$DEnd;i++)) do
	echo mv ${Type}_2020${DSpc}${i}* ${Type}_2020${DSpc}${i}_${Ntag}.${Suffix}
done

