#!/bin/bash



filename=/tmp/HA_install_log_`date +%Y-%m-%d_%H:%M:%S`.txt

ECHO()
{
	echo $1 | tee -a $filename
}

ECHO "start to test"
ECHO $filename 
ECHO "hello world!" 

#1: first please be sure that hostname and ip address and DNS are configured correctly

if (whiptail --title "precondition" --yesno "first please be sure that hostname and ip address and DNS are configured correctly! continues?" 10 60) then
    ECHO "You chose Yes. Exit status was $?."
    vi /etc/sysconfig/network
    vi /etc/sysconfig/network-scripts/ifcfg-eth0
else
    ECHO "You chose No. Exit status was $?."
fi

#2: add hostname and ip address in /etc/hosts
if (whiptail --title "configure hosts" --yesno "start to configure hosts?" 10 60) then
    ECHO "start to configure /etc/hosts"
    vi /etc/hosts
else
    ECHO "cancel configure /etc/hosts"
fi