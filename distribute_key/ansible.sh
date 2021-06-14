#!/bin/bash
#Author:        daihaorui
#Mobile:        13738756428
#Date:          2021/02/08
#Description:   This script can implement key distribution and add host list, but it is not recommended to use, without too much testing, you can try the key module list module test separately
#Caution:       If demand for group have not execute the script, to switch to/rsync/register/scripts/distribute_key distribute_key. Sh
#Version:       v4

[ -f /etc/init.d/functions ] && . /etc/init.d/functions
if ! grep "\[test\]" /etc/ansible/hosts > /dev/null
then
  echo '[test]' >> /etc/ansible/hosts
fi
cat /root/distribute_key/ip_port_pass.txt|\
while read line
do
  Name_info=`echo $line | awk '{print $1}'`
  IP_info=`echo $line | awk '{print $2}'`
  Port_info=`echo $line | awk '{print $3}'`
  Pass_info=`echo $line | awk '{print $4}'`
  Find="$Name_info ansible_host=$IP_info ansible_ssh_user=root ansible_ssh_port=$Port_info"
  sshpass -p$Pass_info ssh-copy-id -i ~/.ssh/id_rsa.pub -p $Port_info root@$IP_info -o StrictHostKeyChecking=no 1>/dev/null 2>>/root/distribute_key/error.log
  if [ $? -eq 0 ]
  then
    action "host $IP_info 分发密钥"    /bin/true
    if ! grep "$Find" /etc/ansible/hosts > /dev/null
    then
      echo $Find >> /etc/ansible/hosts
      action "$IP_info Successfully added"    /bin/true
      echo ""
    else
      action "Unable to add because it already exists"    /bin/true
      echo ""
    fi
  else
    action "host $IP_info 分发密钥"    /bin/false
    echo ""
  fi
done
