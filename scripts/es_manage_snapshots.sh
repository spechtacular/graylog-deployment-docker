#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh

# need the jq binary:
# - yum install jq
# - apt-get install jq
# 

curl -XGET "${ES_URL}/_snapshot/${ES_REPO}/_all?pretty"

ES_SNAPSHOTS=$(curl -XGET "${ES_URL}/_snapshot/${ES_REPO}/_all" | jq -r ".snapshots[:-2][].snapshot")

SLEN=${#ES_SNAPSHOTS[@]}
echo "Found $SLEN snapshots to delete"

for ((i=0; i<${SLEN}; i++)); 
do
 echo "Deleting snapshot=${ES_SNAPSHOTS[$i]};"
 #curl -XDELETE "$ES_URL/_snapshot/$REPO/$SNAPSHOT?pretty"
done
