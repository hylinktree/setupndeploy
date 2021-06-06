#!/bin/bash
PORTMAP="-p 80:80 -p 443:443 -p 8080:8080"
IMGNAME=gdca/basenginx
CNTNAME=c_nginx
if [ x$1 = x ]; then
	docker stop ${CNTNAME} 2>/dev/null
	docker rm ${CNTNAME} 2>/dev/null
	docker run --name ${CNTNAME} --restart always -d $PORTMAP $IMGNAME
else
	docker run --rm -it $PORTMAP $IMGNAME bash
fi
