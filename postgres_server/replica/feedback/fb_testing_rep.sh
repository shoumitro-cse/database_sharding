# for PostgreSQL 15 main database
sudo -u postgres psql
CREATE USER feedback_rep REPLICATION LOGIN ENCRYPTED PASSWORD 'mektec_@1%^8$';
ALTER USER postgres WITH PASSWORD '1234';

sudo nano /etc/postgresql/15/main/pg_hba.conf
host    replication    feedback_rep     0.0.0.0/0               trust # any ip addrees(must required)
host    replication    feedback_rep     127.0.0.1/32            trust # only localhost
host    all            all              0.0.0.0/0               md5

sudo nano /etc/postgresql/15/main/postgresql.conf
wal_level = replica
max_wal_senders =  10 #How many secondaries can connect 
listen_addresses='*'

sudo systemctl restart postgresql


# postgres server backup
pg_basebackup -h 127.0.0.1 -p 5432 -D ./fb_data -U feedback_rep -P -v
pw: mektec_@1%^8$

# must create this dir
mkdir $(pwd)/fb_data/standby.signal

# for main or replica both must use it
sudo nano $(pwd)/fb_data/postgresql.conf
wal_level = replica
max_wal_senders =  10 #How many secondaries can connect 

# it's only for standby or replica database and must comment for main database
nano ./fb_data/postgresql.conf
primary_conninfo = 'host=host.docker.internal port=5432 user=feedback_rep password=mektec_@1%^8$'
hot_standby = on			# "off" disallows queries during recovery

# for replica data
cp -r $(pwd)/fb_data $(pwd)/replica0_data
cp -r $(pwd)/fb_data $(pwd)/replica1_data
cp -r $(pwd)/fb_data $(pwd)/replica2_data

sudo rm -rf $(pwd)/replica0_data
sudo rm -rf $(pwd)/replica1_data
sudo rm -rf $(pwd)/replica2_data
 
sudo docker run --restart always --name replica0_db --add-host=host.docker.internal:host-gateway -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=1234  -v $(pwd)/replica0_data:/var/lib/postgresql/data -p 5433:5432 -it postgres:15.1
sudo docker restart replica0_db

sudo docker run --restart always --name replica1_db --add-host=host.docker.internal:host-gateway -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=1234  -v $(pwd)/replica1_data:/var/lib/postgresql/data -p 5434:5432 -it postgres:15.1
sudo docker restart replica1_db
 
sudo docker run --restart always --name replica2_db --add-host=host.docker.internal:host-gateway -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=1234  -v $(pwd)/replica2_data:/var/lib/postgresql/data -p 5435:5432 -it postgres:15.1
sudo docker restart replica2_db


psql 'postgres://postgres:1234@0.0.0.0:5432/postgres?sslmode=disable'
psql -h 0.0.0.0 -p 5432 -U postgres


sudo docker stop replica0_db replica1_db replica2_db  
sudo docker rm replica0_db replica1_db replica2_db  
sudo docker restart replica0_db replica1_db replica2_db  


# for main db
SELECT * FROM pg_stat_replication;
CREATE TABLE student(
   ID             INT   ,
   NAME           TEXT ,
   AGE            INT ,
   ADDRESS        CHAR(50)
);
insert into student(id,name,age,address) values(100,'Shoumitro Roy','23','Jessore'); 
select * from student;
select count(*) from student;


# for PostgreSQL 15 main database
psql 'postgres://postgres:1234@0.0.0.0:5432/postgres?sslmode=disable'


# for replica
psql 'postgres://postgres:1234@0.0.0.0:5433/postgres?sslmode=disable'
psql 'postgres://postgres:1234@0.0.0.0:5434/postgres?sslmode=disable'
psql 'postgres://postgres:1234@0.0.0.0:5435/postgres?sslmode=disable'
