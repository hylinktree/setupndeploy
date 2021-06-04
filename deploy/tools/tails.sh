#!/bin/bash
for((;;));do
	for f in /g2log/*log ; do
		echo listing $f
		tail -n10 $f
		sleep 6
	done
done
