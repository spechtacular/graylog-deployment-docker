#!/bin/sh
# drop database before restore?
export CONTAINER_NAME="mongodb"
export DATABASE_NAME="graylog"

docker exec -i ${CONTAINER_NAME} mongo ${DATABASE_NAME} --eval "db.dropDatabase()"     

