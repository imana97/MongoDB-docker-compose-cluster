// Connect to the MongoDB instances using mongosh
const { MongoClient } = require('mongodb');

async function initiateCluster() {
  const configClient = new MongoClient('mongodb://localhost:10001');
  const shardClient = new MongoClient('mongodb://localhost:20001');

  try {
    // Connect to the config server replica set
    await configClient.connect();
    const configDb = configClient.db('admin');
    await configDb.command({
      replSetInitiate: {
        _id: "configReplSet",
        configsvr: true,
        members: [
          { _id: 0, host: "localhost:10001" }
        ]
      }
    });

    // Connect to the shard replica set
    await shardClient.connect();
    const shardDb = shardClient.db('admin');
    await shardDb.command({
      replSetInitiate: {
        _id: "shard1rs",
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
      }
    });

    // Connect to the mongos router and add the shard
    const mongosClient = new MongoClient('mongodb://localhost:30000');
    await mongosClient.connect();
    const mongosDb = mongosClient.db('admin');
    await mongosDb.command({
      addShard: "shard1rs/localhost:20001,localhost:20002,localhost:20003,localhost:20004,localhost:20005,localhost:20006,localhost:20007,localhost:20008,localhost:20009,localhost:20010"
    });

    console.log('Cluster initiated successfully');
  } finally {
    await configClient.close();
    await shardClient.close();
  }
}

initiateCluster().catch(console.error);
