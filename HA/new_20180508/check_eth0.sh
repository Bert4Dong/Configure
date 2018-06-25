#!/bin/sh



chech_state()
{
	cur_state=1
  prev_state=1

	  if [ `ifconfig $1 | grep -i running | wc -l` -eq 0 ]; then
        cur_state=0
    elif [ `ifconfig $1 | grep -i running | wc -l` -ne 0 ]; then
        cur_state=1
    else
        echo "$1 state is ERROR" >> /tmp/check_$1.txt
    fi

    if [ ${cur_state} -eq 0 -a $prev_state -eq 1 ]; then
        echo "$1 is DOWN cur_state=$cur_state"  >> /tmp/check_$1.txt
    fi

    if [ $cur_state -eq 1 -a $prev_state -eq 0 ]; then
        echo "$1 is RUNNING cur_state=$cur_state" >> /tmp/check_$1.txt
        service pacemaker restart
        sleep 5s
    fi
  
    sleep 1s
    prev_state=$cur_state
}

while true
do
 network_cards=`ifconfig | grep eth | awk '{print $1}' | grep -v :`
 
 for interface in $network_cards
 do
	   chech_state $interface
 done
done
