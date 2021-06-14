#!/bin/bash
#Author:	daihaorui
#Mobile:	13738756428
#Date:		2021/02/08
#Description:	This script is only used for key distribution
#Caution:	
#Version:	v1

[ -f /etc/init.d/functions ] && . /etc/init.d/functions
cat /root/distribute_key/ip_port_pass.txt|\
while read line
do
  IP_info=`echo $line | awk '{print $1}'`
  Pass_info=`echo $line | awk '{print $2}'`
  Port_info=`echo $line | awk '{print $3}'`
  sshpass -p$Pass_info ssh-copy-id -i ~/.ssh/id_rsa.pub -p $Port_info root@$IP_info -o StrictHostKeyChecking=no &>/dev/null
  if [ $? -eq 0 ]
  then
    action "host $IP_info 分发密钥"    /bin/true
    echo ""
  else
    action "host $IP_info 分发密钥"    /bin/false
    echo ""
  fi
done
