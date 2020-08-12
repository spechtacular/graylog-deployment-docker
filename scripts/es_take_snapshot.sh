#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh

results=`curl -XPUT -s ${ES_URL}/_snapshot/${ES_REPO}/${snapshot_name}?wait_for_completion=true`
printf "$results \n\n"


