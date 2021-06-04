#!/bin/bash
cp ~/pcbox.tgz . 2>/dev/null
docker build . --no-cache -t gdca/pcbox

