#!/bin/bash

export CONTAINER_NAME="mongodb"

USAGE_MESSAGE="Usage: $0 [-h] [-d backup_directory]
    -h help
    -d {backup_directory} to be restored"

while getopts hd: args
do case "$args" in
    d) BACKUP_DIRECTORY="$OPTARG";;
    h) echo "${USAGE_MESSAGE}"
        exit 1;;
    :) echo "${USAGE_MESSAGE}"
        exit 1;;
    *) echo "${USAGE_MESSAGE}"
        exit 1;;
esac
done

shift $(($OPTIND - 1))

docker cp ${BACKUP_DIRECTORY} ${CONTAINER_NAME}:/data

docker exec -i ${CONTAINER_NAME} mongorestore /data/$( basename ${BACKUP_DIRECTORY})

