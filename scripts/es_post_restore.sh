#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh


USAGE_MESSAGE="Usage: $0 [-h] [-s snapshot]
    -h help
    -s {snapshot} to use for restore"

while getopts hs: args
do case "$args" in
    s) SNAPSHOT="$OPTARG";;
    h) echo "${USAGE_MESSAGE}"
        exit 1;;
    :) echo "${USAGE_MESSAGE}"
        exit 1;;
    *) echo "${USAGE_MESSAGE}"
        exit 1;;
esac
done

shift $(($OPTIND - 1))



curl -XPOST "${ES_URL}/_snapshot/es_backup/${SNAPSHOT}/_restore"
