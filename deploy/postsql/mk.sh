#!/bin/bash
TARGET=postsql

if [[ $# > 0 && $1 == --1 && -d ${TARGET}/setting_api1 ]]; then
	rm -rf ${TARGET}/setting
	rm -rf ${TARGET}/setting_api2
	mv ${TARGET}/setting_api1 ${TARGET}/setting
elif [[ $# > 0 && $1 == --2 && -d ${TARGET}/setting_api2 ]]; then
	rm -rf ${TARGET}/setting
	rm -rf ${TARGET}/setting_api1
	mv ${TARGET}/setting_api2 ${TARGET}/setting
fi
tar zcvf ${TARGET}.tgz ${TARGET}
docker build . --no-cache -t gdca/${TARGET}

