sudo apt update
sudo apt install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx curl


sudo apt install python3.8-venv
python3 -m venv venv

sudo apt install ffmpeg

sudo service postgresql restart
sudo systemctl restart postgresql
sudo systemctl stop  postgresql



sudo -u postgres psql
CREATE DATABASE socialmediadb;

SHOW server_encoding;
SET server_encoding = 'UTF8';

show client_encoding;
SET client_encoding = 'UTF8';

CREATE USER meektecdbuser WITH PASSWORD 'MeektecIt123';
ALTER ROLE meektecdbuser SET client_encoding TO 'utf8';
ALTER ROLE meektecdbuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE meektecdbuser SET timezone TO 'UTC';

GRANT ALL PRIVILEGES ON DATABASE socialmediadb TO meektecdbuser;
REVOKE ALL PRIVILEGES ON DATABASE socialmediadb FROM meektecdbuser;


**********************************************************************************
set encoding utf-8
# https://www.shubhamdipt.com/blog/how-to-change-postgresql-database-encoding-to-utf8/
 
 sudo -u postgres psql
 UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
 DROP DATABASE template1;
CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING 'UTF8' LC_CTYPE 'en_US.UTF-8' LC_COLLATE 'en_US.UTF-8';
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
\c template1;
VACUUM FREEZE;


CREATE DATABASE "feedback" WITH ENCODING 'UTF8' LC_CTYPE 'en_US.UTF-8' LC_COLLATE 'en_US.UTF-8';
GRANT ALL PRIVILEGES ON DATABASE feedback TO meektecdbuser;

sudo -u postgres pg_dump your_database > dump.sql​
sudo -u postgres dropdb your_database​
sudo -u postgres psql feedback < dump.sql​
----------------------------------------------------------------------------------


ALTER USER user_name WITH PASSWORD 'new_password';
ALTER USER postgres WITH PASSWORD '1234';

ALTER ROLE postgres SET client_encoding TO 'utf8';
SELECT usename, useconfig FROM pg_shadow;
SELECT current_user;
SELECT version();
sudo -u postgres psql --dbname=socialmediadb -c "SHOW client_encoding;" | cat

client_encoding?
So basically, psql is only using LATIN1 encoding for commands involving the terminal.
How can you fix this? Well, there are a few possible ways.
One would be to do as the docs suggest and set the PGCLIENTENCODING environment variable to UTF8 somewhere persistent, such as ~/.profile or ~/.bashrc to affect only your user, or /etc/environment to affect the whole system (see How to permanently set environmental variables).

/etc/environment
PGCLIENTENCODING=UTF8
PGHOST=''
export PGCLIENTENCODING=UTF8

sudo nano /etc/postgresql/12/main/postgresql.conf
client_encoding = 'UTF8'
sudo systemctl restart postgresql


sudo pg_dropcluster 12 main --stop
sudo pg_dropcluster 14 main_pristine --stop


sudo -u postgres pg_dump socialmediadb > dump.sql​
sudo -u postgres dropdb socialmediadb 

# Database version upgrade
# https://techviewleo.com/how-to-install-postgresql-database-on-ubuntu/ (14)
# https://gorails.com/guides/upgrading-postgresql-version-on-ubuntu-server
To find the installed versions that you currently have on your machine, you can run the following:

$ dpkg --get-selections | grep postgres
postgresql-14                   install
postgresql-15                   install
postgresql-client               install
postgresql-client-14                install
postgresql-client-15                install
postgresql-client-common            install
postgresql-common               install
You can also list the clusters that are on your machine by running

$ pg_lsclusters
Ver Cluster Port Status Owner    Data directory               Log file
14 main    5432 online postgres /var/lib/postgresql/14/main /var/log/postgresql/postgresql-14-main.log
15 main    5433 online postgres /var/lib/postgresql/15/main /var/log/postgresql/postgresql-15-main.log
2. Stop Postgres before we make any changes
First thing's first, we need to stop any services using postgres so we can safely migrate our database.

sudo service postgresql stop
3. Rename the new Postgres version's default cluster
When Postgres packages install, they create a default cluster for you to use. We need to rename the new postgres cluster so that when we upgrade the old cluster the names won't conflict.

sudo pg_renamecluster 15 main main_pristine
4. Upgrade the old cluster to the latest version
Replace the version (14) here with the old version of Postgres that you're currently using.

sudo pg_upgradecluster 14 main
5. Make sure everything is working again
We can start Postgres back up again and this time it should be running the new postgres 15 cluster.

sudo service postgresql start
You should also see that the old cluster is down and the new version of Postgres is up:

$ pg_lsclusters
Ver Cluster       Port Status Owner    Data directory                       Log file
14  main          5434 down   postgres /var/lib/postgresql/14/main          /var/log/postgresql/postgresql-14-main.log
15  main          5432 online postgres /var/lib/postgresql/15/main          /var/log/postgresql/postgresql-15-main.log
15  main_pristine 5433 online postgres /var/lib/postgresql/15/main_pristine /var/log/postgresql/postgresql-15-main_pristine.log
6. Drop the old cluster
Optionally, you can drop the old cluster once you've verified the new one works and you don't need the old cluster anymore.

sudo pg_dropcluster 14 main --stop
You can also drop the pristine database from the newer version as well.

sudo pg_dropcluster 15 main_pristine --stop




