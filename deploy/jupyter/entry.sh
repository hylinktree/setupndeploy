#!/bin/bash
mkdir /mnt/jupyter/notebooks 2>/dev/null
jupyter notebook --notebook-dir=/mnt/jupyter/notebooks --ip='*' --port=8888 --no-browser --allow-root
