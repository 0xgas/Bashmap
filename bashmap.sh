#!/bin/bash

MINPORT=1
MAXPORT=1000
TIMEOUT="0.05s"
if [ $# -lt 1 ]; then
	echo "Usage: $0 <ip> <min_port> <max_port> <timeout>"
	echo "default min port is 1"
	echo "default max port is 1000"
	echo "default timeout is 0.05s"
	exit
fi

IP=$1
if [ $# -eq 4 ];then
	TIMEOUT="$4"
fi
if [ $# -ge 3 ];then
	MAXPORT=$3
fi
if [ $# -ge 2 ];then
	MINPORT=$2
fi


echo "Scanning $IP from port $MINPORT to port $MAXPORT... (timeout $TIMEOUT)"
tot=$((MAXPORT-MINPORT))
for (( i=$MINPORT; i<=$MAXPORT; i++ )); do 
	timeout $TIMEOUT \
	bash -c \
	"(</dev/tcp/$IP/$i) >/dev/null 2>&1" && \
	echo -e "\nOpen port:\t$i" || \
	echo -ne "($((i-MINPORT))/$tot)\r"; 
done
echo
