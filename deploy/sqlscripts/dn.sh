#!/bin/bash
RACC="BigEDA@124.9.14.7"
RBASE="/home/BigEDA/gdca/g2"
RHOST="${RACC}:${RBASE}"
scp ${RHOST}/sqlscripts/* .
