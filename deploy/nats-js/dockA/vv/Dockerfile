FROM alpine:latest

RUN apk add --no-cache bash curl jq libc6-compat 
	

WORKDIR /opt
COPY nats-server ./
#COPY bin/ /bin/
#COPY usr/bin /usr/bin/

#ENTRYPOINT [ "/bin/nats-server" ]
#CMD [ "-js" ]
