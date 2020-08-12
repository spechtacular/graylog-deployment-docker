#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh
results=`curl -XDELETE "${ES_URL}/_snapshot/${ES_REPO}"`
printf "$results\n\n"

