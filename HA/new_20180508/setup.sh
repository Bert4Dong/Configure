#!/bin/bash

filename=/tmp/HA_install_log_`date +%Y-%m-%d_%H:%M:%S`.txt
IPv4=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
network_card_count=`ifconfig | grep eth | awk '{print $1}' | grep -v : | wc -l`
HOST_NAME=`grep HOSTNAME /etc/sysconfig/network | awk -F"=" '{print $2}'`
   
ECHO()
{
    echo $1 | tee -a $filename
}

ConfigureNetwork()
{
    ECHO "Configure network:"

    IPADDR=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
    PREFIX=""
    GATEWAY=""
    DNS1=""
    DNS2=""

    if (grep ONBOOT=yes /etc/sysconfig/network-scripts/ifcfg-eth0) then
        ECHO "ONBOOT=yes has been configured"
    else
        if (grep ONBOOT /etc/sysconfig/network-scripts/ifcfg-eth0) then
            sed -i 's/^ONBOOT=.*/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "ONBOOT=yes is configured"
        else
            echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "ONBOOT=yes is appended"
        fi
    fi

    if (grep BOOTPROTO=static /etc/sysconfig/network-scripts/ifcfg-eth0) then
        ECHO "BOOTPROTO=static has been configured"
    else
        if (grep BOOTPROTO /etc/sysconfig/network-scripts/ifcfg-eth0) then
            sed -i 's/^BOOTPROTO=.*/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "BOOTPROTO=static is configured"
        else 
            echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "BOOTPROTO=static is appended"
        fi
    fi   

    ECHO "Enter IPADDR [$IPADDR]:"
    read REPLY
    if [ ! -z $REPLY ]; then
        IPADDR=$REPLY

        if (grep IPADDR /etc/sysconfig/network-scripts/ifcfg-eth0) then
            ECHO "IPADDR=$IPADDR"
            sed -i 's/^IPADDR=.*/IPADDR='$IPADDR'/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        else
            echo "IPADDR=$IPADDR" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "The IPADDR is $IPADDR"
        fi
    else
        ECHO "IPADDR hasn't been configured, please confirm it!!!"
    fi

    ECHO "Enter PREFIX [$PREFIX]:"
    read REPLY
    if [ ! -z $REPLY ]; then 
        PREFIX=$REPLY

        if (grep PREFIX /etc/sysconfig/network-scripts/ifcfg-eth0) then
            ECHO "PREFIX=$PREFIX" 
            sed -i 's/^PREFIX=.*/PREFIX='$PREFIX'/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        else
            echo "PREFIX=$PREFIX" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "The PREFIX is $PREFIX"
        fi
    else
        ECHO "PREFIX hasn't been configured, please confirm it!!!"

    fi

    ECHO "Enter GATEWAY [$GATEWAY]:"
    read REPLY
    if [ ! -z $REPLY ]; then 
        GATEWAY=$REPLY

        if (grep GATEWAY /etc/sysconfig/network-scripts/ifcfg-eth0) then
            ECHO "GATEWAY=$GATEWAY" 
            sed -i 's/^GATEWAY=.*/GATEWAY='$GATEWAY'/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        else
            echo "GATEWAY=$GATEWAY" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "The GATEWAY is $GATEWAY"
        fi
    else
        ECHO "GATEWAY hasn't been configured, please confirm it!!!"

    fi

    ECHO "Enter DNS1 [$DNS1]:"
    read REPLY
    if [ ! -z $REPLY ]; then
        DNS1=$REPLY

        if (grep DNS1 /etc/sysconfig/network-scripts/ifcfg-eth0) then
            ECHO "DNS1=$DNS1"
            sed -i 's/^DNS1=.*/DNS1='$DNS1'/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        else
            echo "DNS1=$DNS1" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "The DNS1 is $DNS1"
        fi
    else
        ECHO "DNS1 hasn't been configured, please confirm it!!!"

    fi

    ECHO "Enter DNS2 [$DNS2]:"
    read REPLY
    if [ ! -z $REPLY ]; then
        DNS2=$REPLY

        if (grep DNS2 /etc/sysconfig/network-scripts/ifcfg-eth0) then
            ECHO "DNS2=$DNS2"
            sed -i 's/^DNS2=.*/DNS2='$DNS2'/g' /etc/sysconfig/network-scripts/ifcfg-eth0
        else
            echo "DNS2=$DNS2" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            ECHO "The DNS2 is $DNS2"
        fi
    else
        ECHO "DNS2 hasn't been configured, please confirm it!!!"

    fi

}

ConfigureHostName()
{
    ECHO "start configure hostname"
 
    ECHO "Enter hostname [$HOST_NAME]:"
    read REPLY
    if [ ! -z $REPLY ]; then
        if [ ! $HOST_NAME ]; then
            echo "HOSTNAME=$REPLY" >> /etc/sysconfig/network
        else
            HOST_NAME=$REPLY
            sed -i 's/^HOSTNAME=.*/HOSTNAME='$HOST_NAME'/g' /etc/sysconfig/network
            ECHO "The hostname is $HOST_NAME"
        fi
    fi

}

ConfigureHost()
{
    if ( ! grep IX-A /etc/hosts) then
        echo "#192.168.135.202 IX-A" >> /etc/hosts
    fi

    vi /etc/hosts
}

ConfigureIX()
{
    ixDir=/Polylink/IPPBX/current/conf
    floatingIP="127.0.0.1"

    if [ ! -d "/Polylink/" ]; then
        ECHO "Please install IX, and exit"
        exit  
    fi       

    ECHO "Enter floating IP :"
    read REPLY
    if [ ! -z $REPLY ]; then
        floatingIP=$REPLY 
    else
        ECHO "floating IP MUST be set, exit it!!!"
    fi

    # floating ip and bind_server_ip
    if ( grep  "pbx_floating_ip=" ${ixDir}/vars_sip.xml ) then
        ECHO "delete old pbx_floating_ip and create new"
        sed -i '/pbx_floating_ip=/d' ${ixDir}/vars_sip.xml
        echo "<X-PRE-PROCESS cmd=\"set\" data=\"pbx_floating_ip=${floatingIP}\"/>" >> ${ixDir}/vars_sip.xml
    else
        echo "<X-PRE-PROCESS cmd=\"set\" data=\"pbx_floating_ip=${floatingIP}\"/>" >> ${ixDir}/vars_sip.xml
    fi

    if ( grep  "bind_server_ip=" ${ixDir}/vars_sip.xml ) then
        ECHO "delete old bind_server_ip and create new"
        sed -i '/bind_server_ip=/d' ${ixDir}/vars_sip.xml
        echo '<X-PRE-PROCESS cmd="set" data="bind_server_ip=$${pbx_floating_ip}"/>' >> ${ixDir}/vars_sip.xml
    else
        echo '<X-PRE-PROCESS cmd="set" data="bind_server_ip=$${pbx_floating_ip}"/>' >> ${ixDir}/vars_sip.xml
    fi

    # vars.xml
    if ( grep "api_on_startup=" ${ixDir}/vars.xml) then
        ECHO "delete old api_on_startup and create new one"
        sed -i '/api_on_startup=/d' ${ixDir}/vars.xml
    fi
    sed -i '/<\/include>/i\  <X-PRE-PROCESS cmd="set" data="api_on_startup=system service pacemaker restart"/>' ${ixDir}/vars.xml

    # switch.conf
    if ( grep switchname ${ixDir}/autoload_configs/switch.conf.xml ) then
        sed -i '/switchname/d' ${ixDir}/autoload_configs/switch.conf.xml
    fi
    sed -i '/<\/settings>/i\    <param name="switchname" value="Polylink IPPBX"/>' ${ixDir}/autoload_configs/switch.conf.xml

    # sip profiles
    filelist=`ls ${ixDir}/sip_profiles/*eth*xml`
    for file in $filelist
    do 
    	  ECHO "Configure ${file}"
        if ( grep track-calls ${file} ) then
            sed -i '/track-calls/d' ${file}
        fi
        sed -i '/<\/settings>/i\    <param name="track-calls" value="true"/>' ${file}
        
        if ( grep rtp-ip ${file} ) then
            sed -i '/rtp-ip/d' ${file}
        fi
        sed -i '/<\/settings>/i\    <param name="rtp-ip" value="$${pbx_floating_ip}"/>' ${file}
        
        if ( grep sip-ip ${file} ) then
            sed -i '/sip-ip/d' ${file}
        fi
        sed -i '/<\/settings>/i\    <param name="sip-ip" value="$${pbx_floating_ip}"/>' ${file}
    done
}

ECHO $filename

#0: configure IX
ConfigureIX

#1: configure network
#ConfigureNetwork

#ECHO "restart network service? [yes/no]:"
#read REPLY
#if [ "$REPLY" = "yes" ]; then
#    ECHO "network service is restarting"
#    service network restart
#else
#    ECHO "service network hasn't been restarted, please confirm it!!!"
#fi

#2: configure hostname
ConfigureHostName

#3: configure host
ConfigureHost

#4: forbid selinux
#ECHO "set selinux to disabled"
#/bin/sed -i -e s,'SELINUX=enforcing','SELINUX=disabled', /etc/selinux/config

#5: forbid iptables
ECHO "close iptables"
service iptables save 
service iptables stop 
chkconfig iptables off
service ip6tables stop
chkconfig ip6tables off
chkconfig --del libvirtd

ECHO "configure network"
if (grep net.ipv4.ip_nonlocal_bind=1 /etc/sysctl.conf) then
    ECHO "net.ipv4.ip_nonlocal_bind=1 is configured"
else
    echo 'net.ipv4.ip_nonlocal_bind=1' >> /etc/sysctl.conf       
    ECHO "net.ipv4.ip_nonlocal_bind=1 is appended" 
fi

if (grep net.ipv6.conf.default.disable_ipv6=1 /etc/sysctl.conf) then
    ECHO "net.ipv6.conf.default.disable_ipv6=1 is configured"
else 
    echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
    ECHO "net.ipv6.conf.default.disable_ipv6=1 is appended"
fi

if (grep net.ipv6.conf.all.disable_ipv6=1 /etc/sysctl.conf) then
    ECHO "net.ipv6.conf.all.disable_ipv6=1 is configured"
else
    echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf   
    ECHO "net.ipv6.conf.all.disable_ipv6=1 is appended" 
fi

sysctl -p   

#6. install corosync and pacemaker and crm shell
yum --disablerepo=\* --enablerepo=c6-hd  install -y corosync*
yum --disablerepo=\* --enablerepo=c6-hd  install -y pacemaker*

yum --disablerepo=\* --enablerepo=c6-hd  install -y asciidoc-8.6.9-36.1.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y asciidoc-examples-8.6.9-36.1.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y aws-vpc-move-ip-0.1.20151002-1.2.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y crmsh-3.0.0-6.1.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y crmsh-scripts-3.0.0-6.1.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y crmsh-test-3.0.0-6.1.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y pssh-2.3.1-7.1.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y python-parallax-1.0.1-28.1.noarch
yum --disablerepo=\* --enablerepo=c6-hd  install -y python-pssh-2.3.1-7.1.noarch

#7: modify /etc/corosync/   /etc/corosync/authkey   
network_cards=`ifconfig | grep eth | awk '{print $1}' | grep -v :`

cp ./corosync.conf /etc/corosync/corosync.conf
i=0
j=1

for interface in $network_cards
do
	  IP=`/sbin/ifconfig ${interface} |grep inet | awk '{print $2}'|tr -d "addr:"`
	  sed -i '/rrp_mode: passive/a\ }' /etc/corosync/corosync.conf
    sed -i '/rrp_mode: passive/a\ ttl: 1' /etc/corosync/corosync.conf
    sed -i '/rrp_mode: passive/a\ mcastport: 5406' /etc/corosync/corosync.conf
    sed -i '/rrp_mode: passive/a\ mcastaddr: 239.255.1.'${j}'' /etc/corosync/corosync.conf
    sed -i '/rrp_mode: passive/a\ bindnetaddr: '${IP}'' /etc/corosync/corosync.conf
    sed -i '/rrp_mode: passive/a\ ringnumber: '$i'' /etc/corosync/corosync.conf
    sed -i '/rrp_mode: passive/a\ interface {' /etc/corosync/corosync.conf 
    
    i=$(($i+1))
    j=$(($j+1))
done

cp authkey /etc/corosync/

#8: start corosync and pacemaker
/etc/rc.d/init.d/pacemaker stop
/etc/rc.d/init.d/corosync stop

ECHO "start corosync"
/etc/rc.d/init.d/corosync start

ECHO "start pacemaker"
/etc/rc.d/init.d/pacemaker start


if ( ! grep check_eth0.sh /etc/rc.local ) then
    echo "/etc/rc.d/init.d/pacemaker stop" >> /etc/rc.local 
    echo "sleep 5" >> /etc/rc.local 
    echo "/etc/rc.d/init.d/corosync restart" >> /etc/rc.local 
    echo "sleep 5" >> /etc/rc.local 
    echo "/etc/rc.d/init.d/pacemaker restart" >> /etc/rc.local 
    echo "sleep 5" >> /etc/rc.local 
    echo "/Polylink/DATA/conf/check_eth0.sh &" >> /etc/rc.local 

    cp check_eth0.sh /Polylink/DATA/conf
    chmod +x /Polylink/DATA/conf/check_eth0.sh
fi

#9: crm configure edit
ECHO "please remember to configure crm"

if [ -f /etc/rc.d/init.d/FSSofia ]; then
    mv /etc/rc.d/init.d/FSSofia /etc/rc.d/init.d/FSSofia_`date +%Y-%m-%d_%H:%M:%S`
fi

cp FSSofia /etc/rc.d/init.d
chmod +x /etc/rc.d/init.d/FSSofia

ECHO "start configure crm, please wait 5s."
sleep 1
ECHO "start configure crm, please wait 4s."
sleep 1
ECHO "start configure crm, please wait 3s."
sleep 1
ECHO "start configure crm, please wait 2s."
sleep 1
ECHO "start configure crm, please wait 1s."
sleep 1

#crm configure load xml replace ./cib.txt
#crm configure edit

# add node
crm configure node $HOST_NAME

# configure virtual IP
vip_list=""

for card in $network_cards
do
	  ECHO "Enter floating IP for network interface: ${card}"
    read REPLY
    if [ ! -z $REPLY ]; then
        interface_IP=$REPLY 
    else
        ECHO "floating IP MUST be set, Are you sure?"
    fi
    
    masklen=24
    ECHO "Enter networwork mask: [${masklen}]"
    read REPLY
    if [ ! -z $REPLY ]; then
        masklen=$REPLY 
    fi
    
    crm configure primitive ${card}_vip ocf:heartbeat:IPaddr params ip=${interface_IP} nic=${card}:0 cidr_netmask=${masklen}
    
    temp_str=${vip_list};
    vip_list="${temp_str} ${card}_vip"
    ECHO "vip_list=${vip_list}"
done

crm configure primitive fs lsb:FSSofia op monitor interval=1s enabled=true on-fail=standby meta target-role=Started

#configure group
crm configure group cluster_services ${vip_list} fs

# configure start order
crm configure order fs-after-ip  ${vip_list} fs

crm configure property have-watchdog=false
crm configure property stonith-enabled=false
crm configure property no-quorum-policy=ignore
crm configure rsc_defaults resource-stickiness=100

crm configure verify
crm configure commit


#10 modify ippbxd script
if [ -f /etc/rc.d/init.d/ippbxd ]; then
    mv /etc/rc.d/init.d/ippbxd /etc/rc.d/init.d/ippbxd_`date +%Y-%m-%d_%H:%M:%S`
fi

cp ippbxd /etc/rc.d/init.d/ippbxd

#11: reboot
ECHO "start to reboot[yes/no]."
read REPLY
if [ "$REPLY" = "yes" ]; then
    ECHO "start to reboot"
    reboot
else
    ECHO "cancel to reboot, remember to reboot it by manual!!!"
fi


