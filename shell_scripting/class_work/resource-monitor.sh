#!/bin/bash

## Get disk usage

ROOT_SIZE=$(df -h | grep -E 'xvda1 ' | awk '{print $2}')
ROOT_USED=$(df -h | grep -E 'xvda1 ' | awk '{print $3}')


TOTAL_PROCESS=$(ps -ef | wc -l)

# Memory Usage
MEMORY_TOTAL=$(free -m | grep ^Mem | awk '{print $2}')
MEMORY_USED=$(free -m | grep ^Mem | awk '{print $3}')


# CPU Usage
CPU_USAGE=$((100-$(vmstat | tail -1 | awk '{print $15}')))

# Network Status

TCP_LISTEN=$(ss -ta | grep ^LISTEN | wc -l)
TCP_ESTAB=$(ss -ta | grep ^ESTAB | wc -l)

echo " SERVER RESOURCE USAGE : "
echo "============================="

echo " DISK USAGE: $ROOT_USED/$ROOT_SIZE"
echo " MEMORY USAGE: $MEMORY_USED/$MEMORY_TOTAL"
echo " CPU USAGE: $CPU_USAGE %"
echo " NETWORK STATISTICS:
        LISTENING(TCP) : $TCP_LISTEN
        ESTABLISHED (TCP): $TCP_ESTAB"







