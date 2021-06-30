rm -rf data/
export MAX_MEMORY_STORE=10
export MAX_FILE_STORE=$((1024*1024*1024*300))
./nats-server -c main.conf 
