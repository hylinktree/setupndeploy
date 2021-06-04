#!/bin/bash
for((i=0;;i++)); do
	echo 'loop#' i 'starts @ ' `date`
	docker-compose stop
	sleep $((60*5))
	echo 'loop#' i 'stop @ ' `date`
	docker-compose start
	sleep $((60*20))
done
