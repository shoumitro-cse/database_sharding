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




# postgres server backup (create replica data)
pg_basebackup -h 35.212.152.136 -p 5432 -D ./fb_data -U feedback_rep -P -v
pw: mektec_@1%^8$

# must create this dir
mkdir ./fb_data/standby.signal


# for main or replica both must use it
sudo nano ./fb_data/postgresql.conf
wal_level = replica
max_wal_senders =  10 #How many secondaries can connect 


# it's only for standby or replica database and must comment for main database
nano ./fb_data/postgresql.conf
primary_conninfo = 'host=35.212.152.136 port=5432 user=feedback_rep password=mektec_@1%^8$'
hot_standby = on			# "off" disallows queries during recovery


# for replica data
cp -r ./fb_data ./replica_data
sudo rm -rf ./replica_data



