#!/bin/bash
set -e

if [ $# -eq 0 ]
  then
    jupyter lab --ip=0.0.0.0 --NotebookApp.token='docker' --allow-root --no-browser &> /dev/null
    python test.py
   else
    exec "$@"
fi