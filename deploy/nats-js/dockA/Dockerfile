FROM nats:latest AS repo_nats


FROM ubuntu:18.04 as repo_ubuntu

COPY --from=repo_ubuntu /usr/bin /usr/bin/
COPY --from=repo_ubuntu /bin /bin/

ENTRYPOINT ["/bin/nats-server"]
CMD ["-c", "/nats/conf/nats-server.conf"]

