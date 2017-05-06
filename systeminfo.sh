#!/bin/bash

## Purpose: Collecting system Information Gather server information within a second
## Author Name: Walid Madkour

MAILIST=Madkourone@gmail.com
DOMAIN=domain
TEMP=/tmp/temp
FILE=/tmp/asset/info.txt
USERID=`id -g`
if [ $USERID==0]; then
echo "Script is Running ..."
else
echo "Please run the script using root user"
exit
fi
mkdir /tmp/asset
touch /tmp/temp
touch /tmp/asset/info.txt
echo -e "\n" > $FILE
echo "Collecting System Information" >> $FILE
echo -e "\n" >> $FILE
echo "collecting information...."
echo "Date: `date`" >> $FILE
echo "HostName: `hostname`" >> $FILE
echo "Installed OS Version: `cat /etc/issue |head -1`" >> $FILE
echo "`/sbin/ifconfig -a |grep "inet addr" | awk 'BEGIN { FS = ":" } ; { print $2 }'`" > $TEMP
echo "IP Address : `egrep '^10' $TEMP |awk '{ print $1}'`" >> $FILE

## Identifying Hardware Platform ##
HF=`uname -i`
if [ $HF == i386 ]; then
echo "Hardware Platform: 32Bit" >> $FILE
else if [ $HF == x86_64 ]; then
echo "Hardware Platform: 64Bit" >> $FILE
else
echo "Hardware Not Matched" >> $FILE
fi
fi

## Colleting Hardware Details ##
echo " " >> $FILE
echo "## Hardware Information" >> $FILE
echo " " >> $FILE
echo "Serial Number     : `lshal |grep system.hardware.serial`" >> $FILE
echo "Serial Number     : `/usr/sbin/dmidecode -s system-serial-number`" >> $FILE
echo "Model Number      : `lshal |grep system.hardware.product`" >> $FILE
echo "Model Number      : `/usr/sbin/dmidecode |grep "SKU Number"`" >> $FILE
echo "Hardware Vendor   : `lshal |grep system.hardware.vendor`" >> $FILE
echo "Hardware Info     : `dmesg |grep DMI`" >> $FILE

## Redhat Version ##
echo " " >> $FILE
echo "## OS Version" >> $FILE
head -n1 /etc/issue >> $FILE
echo -en '\n' >> $FILE
uname -a >> $FILE

## CPU Info ##
echo " " >> $FILE
echo " " >> $FILE
echo "## CPU Information" >> $FILE
grep "model name" /proc/cpuinfo >> $FILE

## RAM/MEMORY Info ##
echo " " >> $FILE
echo " " >> $FILE
echo "## Memory Information" >> $FILE
grep MemTotal /proc/meminfo >> $FILE
y=`grep MemTotal /proc/meminfo |awk '{ print $2 }'`
mb="$(( $y / 1024 ))"
gb="$(( $mb / 1024 ))"
echo "RAM : $gb GB" >> $FILE

## Verify the machine is using NIS ##
echo -e '\n' >> $FILE
cat /etc/yp.conf |grep $DOMAIN > /tmp/yptemp.txt
count=`cat /tmp/yptemp.txt | wc -l`
if [ $count -gt 0 ];
then
echo "`hostname` is part of NIS Domain" >> $FILE
cat /etc/yp.conf |grep finnis >> $FILE
else
echo "`hostname` is not part of NIS" >> $FILE
fi
echo -e '\n' >> $FILE
cat /etc/yp.conf |grep domain >> $FILE

echo -e '\n' >> $FILE
echo "Hard Disk Info" >> $FILE
fdisk -l 2>&1 | grep Disk | grep -v "identifier" | grep -v "valid partition" | awk '{print $2,$3,$4}' >> $FILE

echo -e '\n' >> $FILE
echo "Running Services" >> $FILE
service --status-all |grep running. |awk '{ print $1,$5}' >> $FILE


/bin/mail -s "Linux Asset Inventory `hostname`" $MAILIST < $FILE
