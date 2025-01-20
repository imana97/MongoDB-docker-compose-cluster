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
sh.addShard("shardrs/shards1:27017,shards2:27017,shards3:27017,shards4:27017,shards5:27017,shards6:27017,shards7:27017")
EOF
  echo "Shard added to mongos router."
}

function update_config_server() {
  mongosh --port 10001 <<EOF
rs.add({
  host: "configs1:27017"
})
rs.add({
  host: "configs2:27017"
})
rs.add({
  host: "configs3:27017"
})
EOF
  echo "Config server replica set updated."
}

function remove_config_server() {
  read -p "Enter the hostname of the config server to remove (e.g., configs1): " hostname
  mongosh --port 10001 <<EOF
rs.remove("$hostname:27017")
EOF
  echo "Config server $hostname removed."
}

echo "Choose an operation:"
echo "1. Initiate Config Server Replica Set"
echo "2. Initiate Shard Replica Set"
echo "3. Add Shard to Mongos Router"
echo "4. Update Config Server Replica Set"
echo "5. Remove Config Server"
echo "6. Quit"
read -p "Enter choice [1-6]: " choice

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
    update_config_server
    ;;
  5)
    remove_config_server
    ;;
  6)
    echo "Quitting without performing any operation."
    ;;
  *)
    echo "Invalid choice."
    ;;
esac

echo "Operation completed."