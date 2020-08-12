#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh

results=`curl -XPUT ${ES_URL}/_snapshot/${ES_REPO}?pretty -d "${json_data}" -H "${json_header}"`
printf "$results\n\n"


