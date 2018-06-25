#!/bin/sh

eth0_state=1
prev_state=1

while true
do
    if [ `ifconfig eth0 | grep -i running | wc -l` -eq 0 ]; then
        eth0_state=0
    elif [ `ifconfig eth0 | grep -i running | wc -l` -ne 0 ]; then
        eth0_state=1
    else
        echo "eth0 state is ERROR" >> /tmp/check_eth0.txt
    fi

    if [ ${eth0_state} -eq 0 -a $prev_state -eq 1 ]; then
        echo "eth0 is DOWN eth0_state=$eth0_state"  >> /tmp/check_eth0.txt
    fi

    if [ $eth0_state -eq 1 -a $prev_state -eq 0 ]; then
        echo "eth0 is RUNNING eth0_state=$eth0_state" >> /tmp/check_eth0.txt
        service pacemaker restart
        sleep 5s
    fi
  
    sleep 1s
    prev_state=$eth0_state
done
