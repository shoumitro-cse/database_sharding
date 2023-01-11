# https://gorails.com/guides/upgrading-postgresql-version-on-ubuntu-server
# https://www.cherryservers.com/blog/how-to-install-and-setup-postgresql-server-on-ubuntu-20-04
# postgres upgrade 14 to 15.

# install 15
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null
sudo apt update
sudo apt install postgresql postgresql-client -y


sudo apt-get upgrade

dpkg --get-selections | grep postgres
postgresql-14                   install
postgresql-15                   install

#You can also list the clusters that are on your machine by running
pg_lsclusters

output:
Ver Cluster Port Status Owner    Data directory               Log file
14 main    5432 online postgres /var/lib/postgresql/14/main /var/log/postgresql/postgresql-14-main.log
15 main    5433 online postgres /var/lib/postgresql/15/main /var/log/postgresql/postgresql-15-main.log

# Stop Postgres before we make any changes
sudo service postgresql stop

#Rename the new Postgres version's default cluster
sudo pg_renamecluster 15 main main_pristine

# Upgrade the old cluster to the latest version
sudo pg_upgradecluster 14 main

# 5. Make sure everything is working again
sudo service postgresql start

pg_lsclusters

# Drop the old cluster
sudo pg_dropcluster 14 main --stop

# You can also drop the pristine database from the newer version as well.
sudo pg_dropcluster 15 main_pristine --stop

# enter db
sudo -u postgres psql
ALTER USER postgres WITH PASSWORD '1234';

