#!/bin/bash
#Author:        daihaorui
#Mobile:        13738756428
#Date:          2021/02/24
#Description:   
mongod=`which mongod`
mongo=`which mongo`

/usr/bin/mkdir -p /mongodb/38018/conf  /mongodb/38018/log  /mongodb/38018/data
/usr/bin/mkdir -p /mongodb/38019/conf  /mongodb/38019/log  /mongodb/38019/data
/usr/bin/mkdir -p /mongodb/38020/conf  /mongodb/38020/log  /mongodb/38020/data

/usr/bin/cat > /mongodb/38018/conf/mongodb.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/38018/log/mongodb.conf
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/38018/data
  directoryPerDB: true
  #engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: zlib
    indexConfig:
      prefixCompression: true
net:
  bindIp: 0.0.0.0
  port: 38018
replication:
  oplogSizeMB: 2048
  replSetName: configReplSet
sharding:
  clusterRole: configsvr
processManagement: 
  fork: true
EOF

/usr/bin/cp /mongodb/38018/conf/mongodb.conf /mongodb/38019/conf/
/usr/bin/cp /mongodb/38018/conf/mongodb.conf /mongodb/38020/conf/

/usr/bin/sed 's#38018#38019#g' /mongodb/38019/conf/mongodb.conf -i
/usr/bin/sed 's#38018#38020#g' /mongodb/38020/conf/mongodb.conf -i

$mongod -f  /mongodb/38018/conf/mongodb.conf &>/dev/null
$mongod -f  /mongodb/38019/conf/mongodb.conf &>/dev/null
$mongod -f  /mongodb/38020/conf/mongodb.conf &>/dev/null

$mongo --port 38018 admin 2>/dev/null <<EOF
config = {_id: 'configReplSet', members: [
                          {_id: 0, host: '10.0.0.51:38018'},
                          {_id: 1, host: '10.0.0.51:38019'},
                          {_id: 2, host: '10.0.0.51:38020'}]
           }
rs.initiate(config)
exit;
EOF

