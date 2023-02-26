#https://github.com/vbabak/docker-mysql-master-slave.git
#https://arctype.com/blog/mysql-8-create-master-slave-replication/
#https://medium.com/@chrischuck35/how-to-create-a-mysql-instance-with-docker-compose-1598f3cc1bee

docker run --name mysql-container -d mysql:latest -e MYSQL_ROOT_PASSWORD='1234'


# master: 45.58.41.25
# slave: 45.58.40.60


# Configure Master Server
nano /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql
bind-address            = 0.0.0.0  
log_error = /var/log/mysql/error.log
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
max_binlog_size = 500M
slow_query_log = 1

systemctl restart mysql


# docker exec -it mysql_master bash
mysql -u root -p
pw: 1234

#CREATE USER slaveuser@45.58.40.60 IDENTIFIED WITH mysql_native_password BY '1234';
#grant replication slave on *.* to slaveuser@45.58.40.60;
#show grants for slaveuser@45.58.40.60;
#flush privileges;

#GRANT REPLICATION SLAVE ON *.* TO 'slaveuser'@'%' IDENTIFIED BY '1234';
# SHOW GRANTS FOR slaveuser@'%';

SET GLOBAL sync_binlog=1;
CREATE USER slaveuser@mysql_slave IDENTIFIED WITH mysql_native_password BY '1234';
grant replication slave on *.* to slaveuser@mysql_slave;
flush privileges;
show grants for slaveuser@mysql_slave;
SELECT user,authentication_string,plugin,host FROM mysql.user;
exit;


# docker exec -it mysql_master bash
# docker exec -it mysql_slave bash
mysql -u slaveuser -h mysql_master -p
SELECT user,authentication_string,plugin,host FROM mysql.user;



#Configure Slave Server
nano /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
bind-address            = 0.0.0.0  
datadir = /var/lib/mysql
log_bin = /var/log/mysql/mysql-bin.log
server-id = 2
read_only = 1
max_binlog_size = 500M
slow_query_log   = 1

systemctl restart mysql

# docker exec -it mysql_slave bash
mysql -u root -p
Pw: 1234
show master status\G

#CHANGE MASTER TO MASTER_HOST='45.58.41.25', MASTER_USER='slaveuser', MASTER_PASSWORD='1234', MASTER_LOG_FILE='mysql-bin.000002', MASTER_LOG_POS=1047;
CHANGE MASTER TO MASTER_HOST='mysql_master', MASTER_USER='slaveuser', MASTER_PASSWORD='1234', MASTER_LOG_FILE='mysql-bin.000002', MASTER_LOG_POS=1047;
CHANGE MASTER TO MASTER_HOST='mysql_master', MASTER_USER='slaveuser', MASTER_PASSWORD='1234';
start slave;
show slave status\G




# for master
mysql -u root -p
mysql> create database replicadb;
mysql> show databases;

CREATE TABLE student(
   ID             INT   ,
   NAME           TEXT ,
   AGE            INT ,
   ADDRESS        CHAR(50)
);
insert into student(id,name,age,address) values(100,'Shoumitro Roy','23','Jessore'); 
select * from student;
select count(*) from student;

