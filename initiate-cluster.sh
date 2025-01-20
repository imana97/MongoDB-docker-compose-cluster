#!/bin/bash

function initiate_config_server() {
  mongosh --port 10001 <<EOF
rs.initiate({
  _id: "configReplSet",
  configsvr: true,
  members: [
    { _id: 0, host: "configs1:27017" },
    { _id: 1, host: "configs2:27017" },
    { _id: 2, host: "configs3:27017" }
  ]
})
EOF
  echo "Config server replica set initiated."
}

function initiate_shard() {
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
  echo "Shard replica set initiated."
}

function add_shard_to_router() {
  mongosh --port 30000 <<EOF
sh.addShard("shardrs/localhost:20001,localhost:20002,localhost:20003,localhost:20004,localhost:20005,localhost:20006,localhost:20007")
EOF
  echo "Shard added to mongos router."
}

echo "Choose an operation:"
echo "1. Initiate Config Server Replica Set"
echo "2. Initiate Shard Replica Set"
echo "3. Add Shard to Mongos Router"
echo "4. Quit"
read -p "Enter choice [1-4]: " choice

case $choice in
  1)
    initiate_config_server
    ;;
  2)
    initiate_shard
    ;;
  3)
    add_shard_to_router
    ;;
  4)
    echo "Quitting without performing any operation."
    ;;
  *)
    echo "Invalid choice."
    ;;
esac

echo "Operation completed."