#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh

results=`curl -XGET -s "${ES_URL}/_snapshot/_all?pretty"  -H "${json_header}"`
printf "$results \n\n"


