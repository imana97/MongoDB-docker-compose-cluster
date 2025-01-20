#!/bin/bash

# Initiate the config server replica set
mongosh --port 10001 <<EOF
rs.initiate({
  _id: "configReplSet",
  configsvr: true,
  members: [
    { _id: 0, host: "configs:27017" }
  ]
})
EOF

# Wait for 30 seconds to ensure the config server is initiated
sleep 30

# Initiate the shard replica set
mongosh --port 20001 <<EOF
rs.initiate({
  _id: "shardrs",
  members: [
    { _id: 0, host: "shards1:27017" },
    { _id: 1, host: "shards2:27017" },
    { _id: 2, host: "shards3:27017" },
    { _id: 3, host: "shards4:27017" },
    { _id: 4, host: "shards5:27017" },
    { _id: 5, host: "shards6:27017" },
    { _id: 6, host: "shards7:27017" }
  ]
})
EOF

# Wait for 30 seconds to ensure the shard replica set is initiated
sleep 30

# Connect to the mongos router and add the shard
mongosh --port 30000 <<EOF
sh.addShard("shardrs/localhost:20001,localhost:20002,localhost:20003,localhost:20004,localhost:20005,localhost:20006,localhost:20007,localhost:20008,localhost:20009,localhost:20010")
EOF

echo "Cluster initiated successfully