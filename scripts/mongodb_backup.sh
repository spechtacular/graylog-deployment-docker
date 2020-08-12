#!/bin/sh

export CONTAINER_NAME="mongodb"
export DATABASE_NAME="graylog"
export BACKUP_LOCATION="/mnt/shared/mongodb"

export TIMESTAMP=$(date +'%Y%m%d%H%M%S')

docker exec -t ${CONTAINER_NAME} mongodump --out /data/${DATABASE_NAME}-backup-${TIMESTAMP} --db ${DATABASE_NAME}
docker cp ${CONTAINER_NAME}:/data/${DATABASE_NAME}-backup-${TIMESTAMP} ${BACKUP_LOCATION}

