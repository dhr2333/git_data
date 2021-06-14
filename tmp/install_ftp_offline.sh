#!/bin/bash
#
rpm -q vsftpd &> /dev/null
if [ $? -eq 0 ];then
	info=$(rpm -q vsftpd)
	echo "ERROR: The $info has installed ! rpm -e vsftpd"
	exit
fi
#
netstat -ntlp | grep vsftpd
if [ $? -eq 0 ];then
	echo "ERROR: The vsftpd is running !!"
	exit
fi
#
set -e
#URL=http://221.179.144.122:9000/ftp/
BIT=$(uname -i)
[ $BIT != x86_64 ] &&  echo "ERROR: Only be appropriate for x86_64 !" && exit
chattr -ai /usr/sbin
cp -p /usr/local/src/vsftpd_64 /usr/sbin/vsftpd && chmod 755 /usr/sbin/vsftpd
cp -p /usr/local/src/vsftpd.conf /etc/vsftpd.conf
cp -p /usr/local/src/vsftpd.pam_64 /etc/pam.d/vsftpd
mkdir -p -m 0755 /usr/share/vsftpd/empty
echo "vsftpd /etc/vsftpd.conf &" >> /etc/rc.d/rc.local
echo "Success !"
chattr +ai /usr/sbin
vsftpd -v
