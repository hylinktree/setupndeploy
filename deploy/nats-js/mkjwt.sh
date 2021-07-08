rm -rf jwt.conf
nsc generate config --mem-resolver --config-file jwt.conf
./nats-server --signal reload
