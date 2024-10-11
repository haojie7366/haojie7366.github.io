#!/bin/bash
cd haojie7366.github.io
echo "$1 -p $2 -o StrictHostKeyChecking=no" >ssh/1
./push.sh
