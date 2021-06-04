#!/bin/bash
PORTMAP=3721:80
IMGNAME=gdca/nginx
CNTNAME=gninx
if [ x$1 = x ]; then
	docker stop ${CNTNAME} 2>/dev/null
	docker rm ${CNTNAME} 2>/dev/null
	docker run --name ${CNTNAME} --restart always -d -p $PORTMAP $IMGNAME
else
	docker run --rm -d -p $PORTMAP $IMGNAME
fi
