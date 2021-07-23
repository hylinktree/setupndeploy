#!/bin/bash

LST=( "Dockerfile" "main.go" "wiscall.go" "etcd.go" "echosrv.go" "vo.go" "mkremote.sh" )
for s in "${LST[@]}"; do
	TGT=$s
	scp ${TGT} BigEDA@bigsftp:~/gdca/uploads/gcbox/
done
