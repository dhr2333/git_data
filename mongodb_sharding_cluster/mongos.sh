#!/bin/bash
#Author:        daihaorui
#Mobile:        13738756428
#Date:          2021/02/24
#Description:   shard节点节点搭建，共6台，主分别为38021和38024
mongod=`which mongod`
mongo=`which mongo`
mongos=`which mongos`

/usr/bin/mkdir -p /mongodb/38017/conf  /mongodb/38017/log

/usr/bin/cat > /mongodb/38017/conf/mongos.conf <<EOF
systemLog:
  destination: file
  path: /mongodb/38017/log/mongos.log
  logAppend: true
net:
  bindIp: 0.0.0.0
  port: 38017
sharding:
  configDB: configReplSet/10.0.0.51:38018,10.0.0.51:38019,10.0.0.51:38020
processManagement: 
  fork: true
EOF

$mongos -f /mongodb/38017/conf/mongos.conf &>/dev/null

$mongo 10.0.0.51:38017/admin &>/dev/null <<EOF
db.runCommand( { addshard : "sh1/10.0.0.51:38021,10.0.0.51:38022,10.0.0.51:38023",name:"shard1"} )
db.runCommand( { addshard : "sh2/10.0.0.51:38024,10.0.0.51:38025,10.0.0.51:38026",name:"shard2"} )
exit;
EOF
$mongo 10.0.0.51:38017/admin  <<EOF
db.runCommand( { listshards : 1 } )
sh.status();
exit;
EOF
