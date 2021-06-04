#!/bin/bash
GDCA_SERV_URL=http://gdca.io:3721/etcd

if [ -z $GDCA_SERV_URL ]; then
	echo !!No url 
	echo try export GDCA_SERV_URL=http://140.92.24.75:3721/etcd in your .profile
	exit
fi

PRETTY=0

gdrels() {
	if (( $PRETTY == 1 )); then
		curl -ls ${GDCA_SERV_URL}/rels/$* | jq .
	else
		curl -ls ${GDCA_SERV_URL}/rels/$*
	fi	
}

gdserv() {
	if (( $PRETTY == 1 )); then
		printf "`curl -ls ${GDCA_SERV_URL}/serv/$* | jq -r .node.value`\n"
	else
		curl -ls ${GDCA_SERV_URL}/serv/$*
	fi
}

reset_rels(){
	curl -ls ${GDCA_SERV_URL}/rels?recursive=true -XDELETE
	curl -ls ${GDCA_SERV_URL}/rels/helo -XPUT
}

do_listlogs(){
	for((;;));do 
		date
		tail -n20 /g2log/*
		sleep 10
	done
}
getdockerid(){
	# $1, the container name
	# $2, out, the docker id
	local YY
	IFS='.'
	read -ra YY <<< $1
	eval "$2=${YY[1]}"
}

for((;$#>0;)); do
	arg=$1
	shift
	if [ $arg == --0 ]; then
		GDCA_SERV_URL=http://gdca.io:3721/etcd
		continue
	fi
	if [ $arg == --1 ]; then
		GDCA_SERV_URL=http://10.10.28.89:3721/etcd
		continue
	fi
	if [ $arg == --2 ]; then
		GDCA_SERV_URL=http://10.10.28.91:3721/etcd
		continue
	fi
	if [[ $arg == -pretty || $arg == -p ]]; then
		PRETTY=1
		continue
	fi
	if [[ $arg == -serv || $arg == -s ]]; then
		gdserv $*
		exit
	fi
	if [[ $arg == -rels || $arg == -r ]]; then
		gdrels $*
		exit
	fi
	if [[ $arg == --reset ]]; then
		reset_rels
		exit
	fi
	if [[ $arg == --listlogs ]]; then
		do_listlogs
		exit
	fi
	gdrels $arg
	exit
done

echo Nothing to do

