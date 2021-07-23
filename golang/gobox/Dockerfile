FROM gdca/basego:latest
WORKDIR /gcbox
COPY *.go ./
RUN go build -o gcbox
CMD [ "/gcbox/gcbox", "echo", "--terminator" ]
