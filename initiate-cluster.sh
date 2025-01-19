#!/bin/bash

# Initiate the config server replica set
mongosh --port 10001 <<EOF
rs.initiate({
  _id: "configReplSet",
  configsvr: true,
  members: [
    { _id: 0, host: "localhost:10001" }
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
    { _id: 0, host: "localhost:20001" },
    { _id: 1, host: "localhost:20002" },
    { _id: 2, host: "localhost:20003" },
    { _id: 3, host: "localhost:20004" },
    { _id: 4, host: "localhost:20005" },
    { _id: 5, host: "localhost:20006" },
    { _id: 6, host: "localhost:20007" },
    { _id: 7, host: "localhost:20008" },
    { _id: 8, host: "localhost:20009" },
    { _id: 9, host: "localhost:20010" }
  ]
})
EOF

# Wait for 30 seconds to ensure the shard replica set is initiated
sleep 30

# Connect to the mongos router and add the shard
mongosh --port 30000 <<EOF
sh.addShard("shardrs/localhost:20001,localhost:20002,localhost:20003,localhost:20004,localhost:20005,localhost:20006,localhost:20007,localhost:20008,localhost:20009,localhost:20010")
EOF

echo "Cluster initiated successfully"