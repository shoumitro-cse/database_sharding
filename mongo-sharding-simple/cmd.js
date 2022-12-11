// go to router
mongosh --port 27016


// ++++++++++++++++++ my_db +++++++++++++++++++++++++++++++

show dbs
use my_db
sh.enableSharding("my_db")

show collections
sh.shardCollection("my_db.sales", {_id:1})

for(i=0;i<10;i++) { db.sales.insert({"title": "test", valus:i}) }

db.sales.insert({"title": "test"})
db.sales.find()
sh.status()
db.stats()
db.sales.getShardDistribution()


// ++++++++++++++++++ my_db2 +++++++++++++++++++++++++++++++
use my_db2
sh.enableSharding("my_db2")

use my_db2
show collections
sh.shardCollection("my_db2.product", {_id:1})

for(i=0;i<10;i++) { db.product.insert({"title": "product test", valus:i}) }

db.product.insert({"title": "product test"})
db.product.find()
sh.status()


// ++++++++++++++++++++ my_db3 +++++++++++++++++++++++++++++
use my_db3
sh.enableSharding("my_db3")

use my_db3
show collections
sh.shardCollection("my_db3.order", {_id:1})

for(i=0;i<10;i++) { db.order.insert({"title": "order test", valus:i}) }

db.order.insert({"title": "order test"})
db.order.find()
sh.status()



// ++++++++++++++++++++ my_db4 +++++++++++++++++++++++++++++
use my_db4
sh.enableSharding("my_db4")

show collections
sh.shardCollection("my_db4.deliver", {_id:1})

for(i=0;i<10;i++) { db.deliver.insert({"title": "deliver test", valus:i}) }

db.deliver.insert({"title": "deliver test"})
db.deliver.find()
sh.status()