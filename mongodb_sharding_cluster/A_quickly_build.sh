#!/bin/bash
#Author:        daihaorui
#Mobile:        13738756428
#Date:          2021/02/24
#Description:  
pwd=`pwd`

cd /mongodb/;rm 38017 38018 38019 38020 38021 38022 38023 38024 38025 38026 -rf
bash -x /root/sharding_cluster/sharding_cluster.sh &>>$pwd/error.log
bash -x /root/sharding_cluster/configserver.sh &>>$pwd/error.log
bash -x /root/sharding_cluster/mongos.sh &>>$pwd/error.log
netstat -tulnp
