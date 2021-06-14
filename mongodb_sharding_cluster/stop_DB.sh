#!/bin/bash
#Author:        daihaorui
#Mobile:        13738756428
#Date:          2021/02/24
#Description:
mongod=`which mongod`
mongo=`which mongo`
mongos=`which mongos`

$mongo --port 38017 admin &>/dev/null <<EOF
db.shutdownServer()
EOF
$mongod -f  /mongodb/38018/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38019/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38020/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38021/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38022/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38023/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38024/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38025/conf/mongodb.conf --shutdown &>/dev/null
$mongod -f  /mongodb/38026/conf/mongodb.conf --shutdown &>/dev/null
netstat -tulnp
