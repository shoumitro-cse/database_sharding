# https://techviewleo.com/how-to-install-postgresql-database-on-ubuntu/

psql 'postgres://meektecdbuser:MeektecIt123@192.211.62.226:5432/postgres?sslmode=disable'

#Allow password login.
sudo sed -i '/^host/s/ident/md5/' /etc/postgresql/15/main/pg_hba.conf

# Now change the identification method from peer to trust as below.
sudo sed -i '/^local/s/peer/trust/' /etc/postgresql/15/main/pg_hba.conf

sudo nano /etc/postgresql/15/main/pg_hba.conf
# In the file, add the lines below.

# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             0.0.0.0/0                md5

# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
host    all             all             0.0.0.0/0                md5


sudo nano /etc/postgresql/15/main/postgresql.conf
listen_addresses='*'

sudo systemctl restart postgresql
sudo systemctl enable postgresql

# sudo netstat -pan | grep ":5432"
ss -tunelp | grep 5432

sudo ufw allow 5432/tcp


apt install postgresql-client-common

psql 'postgres://meektecdbuser:MeektecIt123@192.211.62.226:5432/postgres?sslmode=disable'


# Create a firewall rule to google cloud port: 5432 and protocol: tcp , ip-range: 0.0.0.0/0 for all person
psql 'postgres://postgres:123478@35.247.75.85:5432/postgres?sslmode=disable'
psql 'postgres://postgres:123478@0.0.0.0:5432/postgres?sslmode=disable'
psql 'postgres://postgres:123478@10.138.0.16:5432/postgres?sslmode=disable'

