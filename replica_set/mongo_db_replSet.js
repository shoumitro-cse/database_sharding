/* 
# with docker composer
https://www.sohamkamani.com/docker/mongo-replica-set/
https://www.youtube.com/watch?v=gChzfhVGqp8
*/


// connect with primary db through terminal
mongo --port 30001


// I wan't to use this db for primarily.
db = (new Mongo('localhost:30001')).getDB('test') 
rs.status()


config = {
	"_id" : "my-mongo-set",
	"members" : [
		{
			"_id" : 0,
			"host" : "mongo1:27017"
		},
		{
			"_id" : 1,
			"host" : "mongo2:27017"
		},
		{
			"_id" : 2,
			"host" : "mongo3:27017"
		}
	]
}


# intitalize replca set
rs.initiate(config)
rs.status()


// connect primary and secondary db using same mongo shell
// db = (new Mongo('localhost:30001')).getDB('test') # Primary db
// db = (new Mongo('localhost:30002')).getDB('test') # Secondary db
// db = (new Mongo('localhost:30003')).getDB('test') # Secondary db


// for port 30001 primary db. it has both read and write permissions 
db = (new Mongo('localhost:30001')).getDB('test')  // Primary db
show collections
db.mycollection.insert({name : 'sample'})
db.mycollection.insert({name : 'medium'})
db.mycollection.insert({name : 'complex'})
db.mycollection.find()
show collections


// for 30002 port secondary db (only read permission)
db = (new Mongo('localhost:30002')).getDB('test') // Secondary db
// db.setSecondaryOk()
// rs.secondaryOk()
rs.slaveOk()
db.mycollection.find()
db.mycollection.insert({name : 'secondary 30002'}) // got error because here don't have any write permission


// for 30003 port secondary db (only read permission)
db = (new Mongo('localhost:30003')).getDB('test') // Secondary db
rs.slaveOk()
db.mycollection.find()
db.mycollection.insert({name : 'secondary 30003'}) // got error because here don't have any write permission

