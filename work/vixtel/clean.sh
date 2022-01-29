#! /bin/bash
#author:        daihaorui
#Mobile:        13738756428
#date:          2020-12-15
#description:   The interface machine gets the data from the big data platform with the granularity of day
#caution:       crontab
#version:       v1

#该脚本用于清理文件，文件流程为:每天4点20执行tywg的脚本,实现自动清理文件，拉取文件，创建目录及更改权限
#
#[root@localhost tywg_ftp_putout_decrypt]# crontab -l
#20 4 * * * bash /home/root1/scripts/tywg.sh
#[root@localhost tywg_ftp_putout_decrypt]# cat  /home/root1/scripts/tywg.sh


YESTERDAY=`date "+%Y%m%d"`

/usr/bin/find /home/root1/rubbsh/tywg_ftp_putout_decrypt -type d -mtime 1 -exec rm -rf {} \;
cd /home/root1/rubbsh/tywg_ftp_putout_decrypt
ftp -v -n -A 10.4.78.150 <<EOF
user g_noc_qoe G1TxNsD62#,ke
binary
prompt off
cd /ftpdata/out_3031/g_noc_qoe/tywg_ftp_putout_decrypt
mget tywg*
close
bye
EOF
/bin/mkdir /home/root1/rubbsh/tywg_ftp_putout_decrypt/$YESTERDAY
/usr/bin/split -l 35000 -d -a 5 /home/root1/rubbsh/tywg_ftp_putout_decrypt/tywg_output_decrypt2 ./$YESTERDAY/tywgsj
chmod 777 -R /home/root1/rubbsh/tywg_ftp_putout_decrypt
