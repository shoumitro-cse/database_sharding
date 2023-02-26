# https://stackoverflow.com/questions/28196440/what-are-the-differences-between-a-node-a-cluster-and-a-datacenter-in-a-cassand

# Cassan
dra cluster
A node is a single machine that runs Cassandra. A collection of nodes holding similar data are grouped in what is known as a "ring" or cluster.

Sometimes if you have a lot of data, or if you are serving data in different geographical areas, it makes sense to group the nodes of your cluster into different data centers. A good use case of this is for an e-commerce website, which may have many frequent customers on the east coast and the west coast. That way your customers on the east coast connect to your east coast DC and your west coast connect to your west coast DC  for faster performance. but ultimately have access to the same dataset both DCs are in the same cluster.


# The hierarchy of elements in Cassandra is:
Cluster
 Data center(s)
   Rack(s)
	 Server(s)
	   Node #(more accurately, a vnode)
	   
A Cluster is a collection of Data Centers.
A Data Center is a collection of Racks.
A Rack is a collection of Servers.
A Server contains 256 virtual nodes (or vnodes) by default.
A vnode is the data storage layer within a server.

Note: A server is the Cassandra software. A server is installed on a machine, 
where a machine is either a physical server, an EC2 instance, or similar.

An individual unit of data is called a partition. And yes, partitions are replicated across multiple nodes. 
Each copy of the partition is called a replica.


In a multi-data center cluster, the replication is per data center. For example, if you have a data center in San Francisco named dc-sf and another in New York named dc-ny then you can control the number of replicas per data center.

As an example, you could set dc-sf to have 3 replicas and dc-ny to have 2 replicas.

Those numbers are called the replication factor. You would specifically say dc-sf has a replication factor of 3, and dc-ny has a replication factor of 2. In simple terms, dc-sf would have 3 copies of the data spread across three vnodes, while dc-sf would have 2 copies of the data spread across two vnodes.

While each server has 256 vnodes by default, Cassandra is smart enough to pick vnodes that exist on different physical servers.

To summarize:

* Data is replicated across multiple virtual nodes (each server contains 256 vnodes by default)
* Each copy of the data is called a replica
* The unit of data is called a partition
* Replication is controlled per data center


## Starting a cluster
docker-compose up --build -d


## Checking cluster status
docker ps -a
docker exec -it node_1 nodetool status
docker exec -it node_2 nodetool status
docker exec -it node_3 nodetool status


# container scale up/down
docker-compose scale node3=2
docker-compose scale node3=2


# we can use any one node from this three nodes for the next process.
docker exec -it node_1 bash
docker exec -it node_2 bash
docker exec -it node_3 bash


# enter cassandra shell
cqlsh


# create my_db database 
CREATE KEYSPACE my_db with replication = {'class':'SimpleStrategy', 'replication_factor': 2};
use my_db;


# create student table
CREATE table student (id int PRIMARY KEY, name text, email text);


insert into student (id, name, email) values(1, 'John Doe', 'john@gmail.com');
insert into student (id, name, email) values(2, 'jack Doe', 'jack@gmail.com');
insert into student (id, name, email) values(3, 'rebis', 'redis@gmail.com');
insert into student (id, name, email) values(4, 'rohim', 'rohim@gmail.com');
insert into student (id, name, email) values(5, 'ab1', 'ab1@gmail.com');
insert into student (id, name, email) values(6, 'ab2', 'ab2@gmail.com');
insert into student (id, name, email) values(7, 'xy1', 'xy1@gmail.com');
insert into student (id, name, email) values(8, 'xy2', 'xy2@gmail.com');
insert into student (id, name, email) values(9, 'xy3', 'xy3@gmail.com');

select * from student;


# check which nodes hold the data
nodetool getendpoints my_db student 1
nodetool getendpoints my_db student 2
nodetool getendpoints my_db student 3


# Three node ip address
172.21.0.2
172.21.0.3
172.21.0.4

# replication_factor=2, so it will use 2 node to store row data of student table through gossiping.
root@1959aeddd713:/# nodetool getendpoints my_db student 1
172.21.0.3
172.21.0.4
root@1959aeddd713:/# nodetool getendpoints my_db student 2
172.21.0.4
172.21.0.2
root@1959aeddd713:/# nodetool getendpoints my_db student 3
172.21.0.2
172.21.0.3
root@1959aeddd713:/# nodetool getendpoints my_db student 4
172.21.0.2
172.21.0.3
root@1959aeddd713:/# nodetool getendpoints my_db student 5
172.21.0.4
172.21.0.2
root@1959aeddd713:/# nodetool getendpoints my_db student 6
172.21.0.4
172.21.0.2
root@1959aeddd713:/# nodetool getendpoints my_db student 7
172.21.0.4
172.21.0.3
root@1959aeddd713:/# nodetool getendpoints my_db student 8
172.21.0.3
172.21.0.4
root@1959aeddd713:/# nodetool getendpoints my_db student 9
172.21.0.4
172.21.0.2





root@8e63480ae3ce:/# nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load        Tokens  Owns (effective)  Host ID                               Rack 
UN  172.21.0.4  168.06 KiB  16      73.7%             f4880515-61f1-49b8-a19d-7cdd83e41adc  rack1
UN  172.21.0.2  173.1 KiB   16      49.2%             b6245b89-19eb-49ab-ba89-c0a243ae0dc1  rack1
UN  172.21.0.3  168.08 KiB  16      77.1%             5f398b39-b04d-4ab5-8a35-19c2cd737f8c  rack1





# multiple dc 
https://kayaerol84.medium.com/cassandra-cluster-management-with-docker-compose-40265d9de076






