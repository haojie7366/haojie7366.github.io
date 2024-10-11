#!/bin/bash
cd haojie7366.github.io
echo $1:$2 >5/ipnat.txt
ssh root@192.168.1.5 "echo $1:$2 >ipnat.txt"
#./push

