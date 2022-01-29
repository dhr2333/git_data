#! /bin/bash
#author:        daihaorui
#Mobile:        13738756428
#date:          2020-12-15
#description:   The interface machine gets the data from the big data platform with the granularity of day
#caution:       crontab
#version:       v2
YESTERDAY=`date "+%Y%m%d"`
#找到22小时前的文件并删除，+一定要
/usr/bin/find /home/root1/rubbsh/tywg_ftp_putout_decrypt -type d -mmin +1320 -exec rm -rf {} \;
#拉取文件到特定目录下
/bin/mkdir /home/root1/rubbsh/tywg_ftp_putout_decrypt
/usr/bin/cd /home/root1/rubbsh/tywg_ftp_putout_decrypt
/usr/bin/ftp -v -n -A 10.4.78.150 <<EOF
user g_noc_qoe G1TxNsD62#,ke
binary
prompt off
cd /ftpdata/out_3031/g_noc_qoe/tywg_ftp_putout_decrypt
mget tywg*
close
bye
EOF
#创建一个文件，用到日期参数，会自动更新文件名
/bin/mkdir /home/root1/rubbsh/tywg_ftp_putout_decrypt/$YESTERDAY
#切割文件，以35000行为一个文件
/usr/bin/split -l 35000 -d -a 5 /home/root1/rubbsh/tywg_ftp_putout_decrypt/tywg_output_decrypt2 ./$YESTERDAY/tywgsj
#权限更改
/usr/bin/chown logeye.logeye /var/rubbsh/tywg_ftp_putout_decrypt/ -R
