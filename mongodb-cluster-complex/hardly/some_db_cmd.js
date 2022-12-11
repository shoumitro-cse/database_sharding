
// ------------- only for client ---------------------------
// go to router01
mongosh --port 27115

// go to router02
mongosh --port 27116
// ----------------------------------------


// --------------- for shard database (not for client)-------------------------

// go to shard01-a
mongosh --port 27122
show dbs

// go to shard01-b
mongosh --port 27125
show dbs

// go to shard01-c
mongosh --port 27128
show dbs

// -----------------------------------------



// ++++++++++ drop database++++++++++++++++
use my_db
db.dropDatabase()


// ++++++++++++++++++ my_db1 +++++++++++++++++++++++++++++++

show dbs
use my_db1
sh.enableSharding("my_db1")

show collections
sh.shardCollection("my_db1.sales", {_id:1})
sh.shardCollection("my_db1.profit", {_id:1})
sh.shardCollection("my_db1.payment", {_id:1})


for(i=0;i<10;i++) { db.sales.insert({"title": "sales test", valus:i}) }
for(i=0;i<5;i++) { db.profit.insert({"title": "profit test", valus:i}) }
for(i=0;i<5;i++) { db.payment.insert({"title": "payment test", valus:i}) }


db.sales.insert({"title": "sales test"})
db.profit.insert({"title": "profit test"})
db.payment.insert({"title": "payment test"})

db.sales.find()
db.profit.find()
db.payment.find()

sh.status()
db.stats()
db.sales.getShardDistribution()
// exit


// ++++++++++++++++++ my_db2 +++++++++++++++++++++++++++++++
use my_db2
sh.enableSharding("my_db2")

use my_db2
show collections
sh.shardCollection("my_db2.product", {_id:1})

for(i=0;i<5;i++) { db.product.insert({"title": "product test", valus:i}) }

db.product.find()
sh.status()


// ++++++++++++++++++++ my_db3 +++++++++++++++++++++++++++++
use my_db3
sh.enableSharding("my_db3")

use my_db3
show collections
sh.shardCollection("my_db3.order", {_id:1})

for(i=0;i<5;i++) { db.order.insert({"title": "order test", valus:i}) }

db.order.find()
sh.status()


// ++++++++++++++++++++ my_db4 +++++++++++++++++++++++++++++
use my_db4
sh.enableSharding("my_db4")

show collections
sh.shardCollection("my_db4.deliver", {_id:1})

for(i=0;i<5;i++) { db.deliver.insert({"title": "deliver test", valus:i}) }

db.deliver.find()
sh.status()