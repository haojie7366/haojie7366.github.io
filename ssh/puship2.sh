#!/bin/bash
cd haojie7366.github.io
echo "$1 -p $2 -o StrictHostKeyChecking=no" >2/ipnat.txt
./push.sh
