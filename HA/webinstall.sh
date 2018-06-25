#!/bin/sh
echo "The program is installing web service now,please wait..."
tar -zxf WebServer.tar.gz -C /
tar -zxf web.tar.gz -C /tomcat5.0/webapps/
#WEBIP=127.0.0.1
WEBDBIP=127.0.0.1
WEBDBPORT=1521
DBADBIP=127.0.0.1
DBADBPORT=1521
WEBDATABASE=oracle
DBADATABASE=oracle
WEBNAME=bms
WEBPASS=bms888
DBANAME=ecm
DBAPASS=ecm888

#echo "Enter you web ip[$WEBIP]:"
#read REPLY
#if [ ! -z $REPLY ]; then
#WEBIP=$REPLY
#fi

echo "Enter customer management database server ip[$WEBDBIP]:"
read REPLY
if [ ! -z $REPLY ]; then
WEBDBIP=$REPLY
fi

echo "Enter customer management database port[$WEBDBPORT]:"
read REPLY
if [ ! -z $REPLY ]; then
WEBDBPORT=$REPLY
fi

echo "Enter customer management database SID[$WEBDATABASE]:"
read REPLY
if [ ! -z $REPLY ]; then
WEBDATABASE=$REPLY
fi

echo "Enter customer management username[$WEBNAME]:"
read REPLY
if [ ! -z $REPLY ]; then
WEBNAME=$REPLY
fi

echo "Enter customer management password[$WEBPASS]:"
read REPLY
if [ ! -z $REPLY ]; then
WEBPASS=$REPLY
fi

echo "Enter system configuration database server ip[$WEBDBIP]:"
read REPLY
if [ ! -z $REPLY ]; then
DBADBIP=$REPLY
else
DBADBIP=$WEBDBIP
fi

echo "Enter system configuration database port[$WEBDBPORT]:"
read REPLY
if [ ! -z $REPLY ]; then
DBADBPORT=$REPLY
else
DBADBPORT=$WEBDBPORT
fi

echo "Enter system configuration database SID[$WEBDATABASE]:"
read REPLY
if [ ! -z $REPLY ]; then
DBADATABASE=$REPLY
else
DBADATABASE=$WEBDATABASE
fi

echo "Enter system configuration username[$DBANAME]:"
read REPLY
if [ ! -z $REPLY ]; then
DBANAME=$REPLY
fi

echo "Enter system configuration password[$DBAPASS]:"
read REPLY
if [ ! -z $REPLY ]; then
DBAPASS=$REPLY
fi

#BMS 
sed -i 's/^WL_CMPool.url=.*/WL_CMPool.url=jdbc:oracle:thin:@'$WEBDBIP':'$WEBDBPORT':'$WEBDATABASE'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties
sed -i 's/^WL_CMPool.user=.*/WL_CMPool.user='$WEBNAME'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties
sed -i 's/^WL_CMPool.password=.*/WL_CMPool.password='$WEBPASS'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties

sed -i 's/^WL_ECMPool.url=.*/WL_ECMPool.url=jdbc:oracle:thin:@'$DBADBIP':'$DBADBPORT':'$DBADATABASE'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties
sed -i 's/^WL_ECMPool.user=.*/WL_ECMPool.user='$DBANAME'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties
sed -i 's/^WL_ECMPool.password=.*/WL_ECMPool.password='$DBAPASS'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties

sed -i 's/^WL_CDRPool.url=.*/WL_CDRPool.url=jdbc:oracle:thin:@'$WEBDBIP':'$WEBDBPORT':'$WEBDATABASE'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties
sed -i 's/^WL_CDRPool.user=.*/WL_CDRPool.user='$WEBNAME'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties
sed -i 's/^WL_CDRPool.password=.*/WL_CDRPool.password='$WEBPASS'/g' /tomcat5.0/webapps/bms/WEB-INF/conf/db.properties

#BMSINQUERY 
sed -i 's/^WL_CMPool.url=.*/WL_CMPool.url=jdbc:oracle:thin:@'$WEBDBIP':'$WEBDBPORT':'$WEBDATABASE'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties
sed -i 's/^WL_CMPool.user=.*/WL_CMPool.user='$WEBNAME'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties
sed -i 's/^WL_CMPool.password=.*/WL_CMPool.password='$WEBPASS'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties

sed -i 's/^WL_ECMPool.url=.*/WL_ECMPool.url=jdbc:oracle:thin:@'$DBADBIP':'$DBADBPORT':'$DBADATABASE'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties
sed -i 's/^WL_ECMPool.user=.*/WL_ECMPool.user='$DBANAME'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties
sed -i 's/^WL_ECMPool.password=.*/WL_ECMPool.password='$DBAPASS'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties

sed -i 's/^WL_CDRPool.url=.*/WL_CDRPool.url=jdbc:oracle:thin:@'$WEBDBIP':'$WEBDBPORT':'$WEBDATABASE'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties
sed -i 's/^WL_CDRPool.user=.*/WL_CDRPool.user='$WEBNAME'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties
sed -i 's/^WL_CDRPool.password=.*/WL_CDRPool.password='$WEBPASS'/g' /tomcat5.0/webapps/bmsinquery/WEB-INF/conf/db.properties

#ECM
sed -i 's/^WL_CMPool.url=.*/WL_CMPool.url=jdbc:oracle:thin:@'$DBADBIP':'$DBADBPORT':'$DBADATABASE'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties
sed -i 's/^WL_CMPool.user=.*/WL_CMPool.user='$DBANAME'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties
sed -i 's/^WL_CMPool.password=.*/WL_CMPool.password='$DBAPASS'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties

sed -i 's/^WL_BMSPool.url=.*/WL_BMSPool.url=jdbc:oracle:thin:@'$WEBDBIP':'$WEBDBPORT':'$WEBDATABASE'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties
sed -i 's/^WL_BMSPool.user=.*/WL_BMSPool.user='$WEBNAME'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties
sed -i 's/^WL_BMSPool.password=.*/WL_BMSPool.password='$WEBPASS'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties

sed -i 's/^WL_CDRPool.url=.*/WL_CDRPool.url=jdbc:oracle:thin:@'$WEBDBIP':'$WEBDBPORT':'$WEBDATABASE'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties
sed -i 's/^WL_CDRPool.user=.*/WL_CDRPool.user='$WEBNAME'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties
sed -i 's/^WL_CDRPool.password=.*/WL_CDRPool.password='$WEBPASS'/g' /tomcat5.0/webapps/ecm/WEB-INF/conf/db.properties
sed -i 's/^MaxPrefix=.*/MaxPrefix=3/g' $WEBDIR/webapps/db.properties.ecm
#INDEX.HMT
#sed -i 's/192.17.1.132/'$WEBIP':8443/g' /tomcat5.0/webapps/ROOT/index.htm

#Init Env
/bin/sed -e '/jdk/d' /etc/profile | sed -e '/CLASSPATH/d' > /tmp/tmp.txt
/bin/cat  /tmp/tmp.txt > /etc/profile

/bin/echo "PATH=/jdk14/bin:\$PATH" >> /etc/profile
/bin/echo "CLASSPATH=.:/jdk14/lib/dt.jar:/jdk14/lib/tools.jar" >> /etc/profile
/bin/echo "JAVA_HOME=/jdk14" >> /etc/profile
/bin/echo "export PATH CLASSPATH JAVA_HOME" >> /etc/profile
/bin/rm -f /tmp/tmp.txt

#Start Tomcat
/bin/sed -e '/jdk/d' /etc/rc.local|sed -e '/tomcat5.0/d' > /tmp/tmp.txt
/bin/cat /tmp/tmp.txt > /etc/rc.local

/bin/echo "export JAVA_HOME=/jdk14" >> /etc/rc.local
/bin/echo "export JDK_HOME=/jdk14" >> /etc/rc.local
/bin/echo "/tomcat5.0/bin/startup.sh" >> /etc/rc.local
/bin/rm -f /tmp/tmp.txt
clear
echo "Web service has been successfully installed!"
