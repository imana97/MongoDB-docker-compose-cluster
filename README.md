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

### Step 2: Customize Docker Compose

You can customize the Docker Compose file to suit your needs. For example, you can change the memory limits, CPU limits, and volume paths.

#### Example for Windows

```yaml
volumes:
  - F:/Database/MongoDBCluster/configs1:/data/db
```

#### Example for Linux

```yaml
volumes:
  - /mnt/f/Database/MongoDBCluster/configs1:/data/db
```

### Step 3: Initiate the Cluster

#### For Linux/MacOS

First, make the script executable:

```sh
chmod +x initiate-cluster.sh
```

Then, run the script:

```sh
./initiate-cluster.sh
```

#### For Windows

Run the batch script:

```sh
initiate-cluster.bat
```

This script will set up the config server replica set, the shard replica set, and add the shard to the cluster.

### Step 4: Using the Cluster in a Node.js Application

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

### Step 5: Stopping the Cluster

To stop the MongoDB containers, run:

```sh
docker-compose down
```

This will stop and remove the containers.

## Credits

Credit to Iman Far (imanfar.com)
