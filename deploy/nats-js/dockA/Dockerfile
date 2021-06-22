FROM nats:latest AS P_NATS


FROM ubuntu:18.04 as P_UBUNTU

COPY --from=P_UBUNTU /usr/bin /usr/bin/
COPY --from=P_UBUNTU /bin /bin/

ENTRYPOINT ["/bin/nats-server"]
CMD ["-c", "/nats/conf/nats-server.conf"]

