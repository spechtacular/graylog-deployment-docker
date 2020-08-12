#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh

results=`curl -XGET -s "${ES_URL}/_cat/snapshots/${ES_REPO}?v&s=id" `

printf  "$results \n\n"


