# MongoDB Sharding Cluster Setup

This guide explains how to set up a MongoDB sharding cluster using Docker Compose and how to use it in a Node.js application.

## Prerequisites

- Docker
- Docker Compose
- Node.js

## Setup

### Step 1: Start the Docker Containers

Run the following command to start the MongoDB containers:

```sh
docker-compose up -d
```

### Step 2: Initialize the Cluster

First, install the npm package dependencies:

```sh
npm install
```

Then, run the following command to initialize the cluster:

```sh
npm start
```

This script will set up the config server replica set, the shard replica set, and add the shard to the cluster.

## Using the Cluster in a Node.js Application

To connect to the MongoDB sharding cluster from a Node.js application, use the following connection string:

```javascript
const { MongoClient } = require('mongodb');

async function main() {
  const uri = "mongodb://localhost:30000";
  const client = new MongoClient(uri);

  try {
    await client.connect();
    console.log("Connected to MongoDB sharding cluster");
    // ... your application code ...
  } finally {
    await client.close();
  }
}

main().catch(console.error);
```

Replace `// ... your application code ...` with your actual application logic.

## Stopping the Cluster

To stop the MongoDB containers, run:

```sh
docker-compose down
```

This will stop and remove the containers.
