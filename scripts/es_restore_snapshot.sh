#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh


restore() {
    local ES_SNAPSHOT=$1
    local index=$2
    local FILE=restore-${ES_REPO}-${ES_SNAPSHOT}.json
    echo "Restoring ${ES_REPO} - $ES_SNAPSHOT - $index"
    echo "Close $index" >> $FILE
    curl -XPOST -u $ES_CREDS "${ES_URL}/$index/_close?pretty" >> $FILE
    echo "Restore ${ES_REPO} - $ES_SNAPSHOT - $index" >> $FILE
    curl -XPOST -u $ES_CREDS "${ES_URL}/_snapshot/${ES_REPO}/$ES_SNAPSHOT/_restore?wait_for_completion=true&pretty" -d"{ \"indices\" : \"$index\", \"ignore_unavailable\": \"true\", \"include_global_state\": \"true\" }" >> $FILE
    EXIT=1
    while [ $EXIT -eq 1 ]; do
        echo " wait_for_completion ${ES_REPO}/$ES_SNAPSHOT"
        sleep 5s
        EXIT=$(curl -XGET -u $ES_CREDS "${ES_URL}/_snapshot/${ES_REPO}/$ES_SNAPSHOT/_status" | grep -c "IN_PROGRESS")
    done
}

#set the SNAPSHOT_NAME and INDEX_NAME you want to restore
restore "SNAPSHOT_NAME" "INDEX_NAME"

#
# Restore a snapshot from our repository
SNAPSHOT=123

# We need to close the index first
curl -XPOST "${ES_URL}/my_index/_close"

# Restore the snapshot we want
curl -XPOST "${ES_URL}/_snapshot/my_backup/$SNAPSHOT/_restore" -d '{
 "indices": "my_index"
}'

# Re-open the index
curl -XPOST "${ES_URL}/my_index/_open"
