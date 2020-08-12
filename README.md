
# URL = logs.mobile.verity.org

# local users required to run elasticsearch, mongodb, and graylog
# graylog user
sudo addgroup --gid 1100 graylog
sudo adduser --no-create-home graylog --gid 1100 --uid 1100

# this is the same gid,uid used by the administrator account on colo vms:
sudo adduser --no-create-home elasticsearch --gid 1000 --uid 1000

# mongodb user
sudo adduser --no-create-home mongodb --gid 999 --uid 1000

sudo usermod -L graylog
sudo usermod -L mongodb

chown -R administrator:administrator usr
chown -R administrator:administrator usr/share/elasticsearch/data
chown -R graylog:graylog usr/share/graylog/data/journal


# elasticsearch details are documented here:
# https://www.elastic.co/guide/en/elasticsearch/reference/5.6/docker.html
# https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html
sudo sysctl -w vm.max_map_count=262144

sudo vi /etc/security/limits.conf
add line:
elasticsearch  -  nofile  65536

# administrator crontab to handle elasticsearch snapshots
MAILTO=theodorespecht@verity.org
# m h  dom mon dow   command
15 4 * * * /home/administrator/vhs-api-graylog/scripts/es_put_snapshot.sh
28 4 * * * /home/administrator/vhs-api-graylog/scripts/es_get_snapshots.sh


# docker authorization
sudo $(aws ecr get-login --no-include-email --region us-west-1) 

# monitor docker resource usage
docker run --rm -it --pid host frapsoft/htop

#  change graylog admin password
echo -n N0tAdmin$PW | shasum -a 256
GRAYLOG_ROOT_PASSWORD_SHA2=shahash string


# root user crontab to manage mongodb backups
MAILTO=theodorespecht@verity.org
# m h  dom mon dow   command
45 3 * * * /home/administrator/vhs-api-graylog/scripts/mongodb_backup.sh
30 4 * * * find /mnt/shared/mongodb/* -type d -ctime +10 -exec rm -rf {} \;
