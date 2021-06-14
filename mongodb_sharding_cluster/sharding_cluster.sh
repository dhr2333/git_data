#!/bin/bash
#Author:        daihaorui
#Mobile:        13738756428
#Date:          2021/02/24
#Description:   shard节点节点搭建，共6台，主分别为38021和38024
mongod=`which mongod`
mongo=`which mongo`

/usr/bin/mkdir -p /mongodb/38021/conf  /mongodb/38021/log  /mongodb/38021/data
/usr/bin/mkdir -p /mongodb/38022/conf  /mongodb/38022/log  /mongodb/38022/data
/usr/bin/mkdir -p /mongodb/38023/conf  /mongodb/38023/log  /mongodb/38023/data
/usr/bin/mkdir -p /mongodb/38024/conf  /mongodb/38024/log  /mongodb/38024/data
/usr/bin/mkdir -p /mongodb/38025/conf  /mongodb/38025/log  /mongodb/38025/data
/usr/bin/mkdir -p /mongodb/38026/conf  /mongodb/38026/log  /mongodb/38026/data

/usr/bin/cat > /mongodb/38021/conf/mongodb.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/38021/log/mongodb.log   
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/38021/data
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
  port: 38021
replication:
  oplogSizeMB: 2048
  replSetName: sh1
sharding:
  #chunkSize: 1
  clusterRole: shardsvr
processManagement: 
  fork: true
EOF

/bin/cp /mongodb/38021/conf/mongodb.conf  /mongodb/38022/conf/
/bin/cp /mongodb/38021/conf/mongodb.conf  /mongodb/38023/conf/

/usr/bin/sed 's#38021#38022#g' /mongodb/38022/conf/mongodb.conf -i
/usr/bin/sed 's#38021#38023#g' /mongodb/38023/conf/mongodb.conf -i

cat > /mongodb/38024/conf/mongodb.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/38024/log/mongodb.log   
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /mongodb/38024/data
  directoryPerDB: true
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
  port: 38024
replication:
  oplogSizeMB: 2048
  replSetName: sh2
sharding:
  #chunkSize: 1
  clusterRole: shardsvr
processManagement: 
  fork: true
EOF

/bin/cp /mongodb/38024/conf/mongodb.conf  /mongodb/38025/conf/
/bin/cp /mongodb/38024/conf/mongodb.conf  /mongodb/38026/conf/

/usr/bin/sed 's#38024#38025#g' /mongodb/38025/conf/mongodb.conf -i
/usr/bin/sed 's#38024#38026#g' /mongodb/38026/conf/mongodb.conf -i

$mongod -f  /mongodb/38021/conf/mongodb.conf &>/dev/null
$mongod -f  /mongodb/38022/conf/mongodb.conf &>/dev/null
$mongod -f  /mongodb/38023/conf/mongodb.conf &>/dev/null
$mongod -f  /mongodb/38024/conf/mongodb.conf &>/dev/null
$mongod -f  /mongodb/38025/conf/mongodb.conf &>/dev/null
$mongod -f  /mongodb/38026/conf/mongodb.conf &>/dev/null

$mongo --port 38021 admin 2>/dev/null <<EOF
config = {_id: 'sh1', members: [
                          {_id: 0, host: '10.0.0.51:38021'},
                          {_id: 1, host: '10.0.0.51:38022'},
                          {_id: 2, host: '10.0.0.51:38023',"arbiterOnly":true}]
           }
rs.initiate(config)
exit;
EOF
$mongo --port 38024 admin 2>/dev/null <<EOF
config = {_id: 'sh2', members: [
                          {_id: 0, host: '10.0.0.51:38024'},
                          {_id: 1, host: '10.0.0.51:38025'},
                          {_id: 2, host: '10.0.0.51:38026',"arbiterOnly":true}]
           }
rs.initiate(config)
exit;
EOF

