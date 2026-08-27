#!/bin/bash
cd haojie7366.github.io
#echo "$1 $2"
#sudo iptables -t nat -A OUTPUT -d $1 -p tcp --dport $2 -j DNAT --to-destination 127.0.0.1:9443
echo "$1:$2" >ssh/5
echo "$1:$2" >ssh/5.txt
sleep 30
scp ssh/5 me@192.168.1.3/haojie7366.github.io/ssh
scp ssh/5.txt me@192.168.1.3/haojie7366.github.io/ssh
#./push.sh
