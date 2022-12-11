#!/bin/bash
docker-compose exec config01 bash -c "mongosh --port 27017 < /scripts/init-configserver.js"
docker-compose exec shard01a bash -c "mongosh --port 27018 < /scripts/init-shard01.js"
docker-compose exec shard02a bash -c "mongosh --port 27019 < /scripts/init-shard02.js"
docker-compose exec shard03a bash -c "mongosh --port 27020 < /scripts/init-shard03.js"
sleep 20
docker-compose exec router bash -c "mongosh < /scripts/init-router.js"


