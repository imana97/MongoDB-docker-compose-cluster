@echo off

setlocal

:menu
echo Choose an operation:
echo 1. Initiate Config Server Replica Set
echo 2. Initiate Shard Replica Set
echo 3. Add Shard to Mongos Router
echo 4. Update Config Server Replica Set
echo 5. Remove Config Server
echo 6. Update Shard Replica Set
echo 7. Remove Shard Replica Set
echo 8. Quit
set /p choice=Enter choice [1-8]: 

if "%choice%"=="1" goto initiate_config_server
if "%choice%"=="2" goto initiate_shard
if "%choice%"=="3" goto add_shard_to_router
if "%choice%"=="4" goto update_config_server
if "%choice%"=="5" goto remove_config_server
if "%choice%"=="6" goto update_shard
if "%choice%"=="7" goto remove_shard
if "%choice%"=="8" goto quit
echo Invalid choice.
goto menu

:initiate_config_server
docker exec -it configs1 mongosh --port 27017 --eval "rs.initiate({
  _id: 'configReplSet',
  configsvr: true,
  members: [
    { _id: 0, host: 'configs1:27017' },
    { _id: 1, host: 'configs2:27017' },
    { _id: 2, host: 'configs3:27017' }
  ]
})"
echo Config server replica set initiated.
goto end

:initiate_shard
docker exec -it shards1 mongosh --port 27017 --eval "rs.initiate({
  _id: 'shardrs',
  members: [
    { _id: 0, host: 'shards1:27017' },
    { _id: 1, host: 'shards2:27017' },
    { _id: 2, host: 'shards3:27017' },
    { _id: 3, host: 'shards4:27017' },
    { _id: 4, host: 'shards5:27017' },
    { _id: 5, host: 'shards6:27017' },
    { _id: 6, host: 'shards7:27017' }
  ]
})"
echo Shard replica set initiated.
goto end

:add_shard_to_router
docker exec -it mongos mongosh --port 27017 --eval "sh.addShard('shardrs/shards1:27017,shards2:27017,shards3:27017,shards4:27017,shards5:27017,shards6:27017,shards7:27017')"
echo Shard added to mongos router.
goto end

:update_config_server
docker exec -it configs1 mongosh --port 27017 --eval "rs.add({ host: 'configs1:27017' })"
docker exec -it configs1 mongosh --port 27017 --eval "rs.add({ host: 'configs2:27017' })"
docker exec -it configs1 mongosh --port 27017 --eval "rs.add({ host: 'configs3:27017' })"
echo Config server replica set updated.
goto end

:remove_config_server
set /p hostname=Enter the hostname of the config server to remove (e.g., configs1): 
docker exec -it configs1 mongosh --port 27017 --eval "rs.remove('%hostname%:27017')"
echo Config server %hostname% removed.
goto end

:update_shard
docker exec -it shards1 mongosh --port 27017 --eval "rs.add({ host: 'shards1:27017' })"
docker exec -it shards1 mongosh --port 27017 --eval "rs.add({ host: 'shards2:27017' })"
docker exec -it shards1 mongosh --port 27017 --eval "rs.add({ host: 'shards3:27017' })"
docker exec -it shards1 mongosh --port 27017 --eval "rs.add({ host: 'shards4:27017' })"
docker exec -it shards1 mongosh --port 27017 --eval "rs.add({ host: 'shards5:27017' })"
docker exec -it shards1 mongosh --port 27017 --eval "rs.add({ host: 'shards6:27017' })"
docker exec -it shards1 mongosh --port 27017 --eval "rs.add({ host: 'shards7:27017' })"
echo Shard replica set updated.
goto end

:remove_shard
set /p hostname=Enter the hostname of the shard to remove (e.g., shards1): 
docker exec -it shards1 mongosh --port 27017 --eval "rs.remove('%hostname%:27017')"
echo Shard %hostname% removed.
goto end

:quit
echo Quitting without performing any operation.
goto end

:end
echo Operation completed.
pause
