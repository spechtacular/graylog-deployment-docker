#!/bin/bash
set -e
source /home/administrator/vhs-api-graylog/scripts/es_variables.sh

TWOWEEKMARK=$(date -d "2 weeks ago" +"%s%3N") # gets tick value for this time two weeks ago. standard GNU command
#echo "two week mark set at $TWOWEEKMARK"

USAGE_MESSAGE="Usage: $0 [-h] [-a all snapshots] [-c current snapshot] [-i indices, _cat/indices?h=i,cd]
    -h help
    -s {snapshot} to use for restore"

indices_option="_cat/indices?h=i,cd"
current_option="_current"
all_option="_all?pretty"
snapshot_option=''
while getopts :haci args
do case "$args" in
    a) snapshot_option=$all_option;;
    c) snapshot_option=$current_option;;
    i) snapshot_option=$indices_option;;
    h) echo "${USAGE_MESSAGE}"
        exit 1;;
    :) echo "${USAGE_MESSAGE}"
        exit 1;;
    *) echo "${USAGE_MESSAGE}"
        exit 1;;
esac
done

echo "so=$snapshot_option"

if [[ "$snapshot_option" != "$all_option" &&  "$snapshot_option" != "$current_option"  && "$snapshot_option" != "$indices_option" ]]; then
   echo "missing or invalid option : ${USAGE_MESSAGE}"
   exit 1
fi

if [[ "$snapshot_option" == "$indices" ]]; then
  echo "indices"
  indices=curl "${ES_URL}/${snapshot_option}"
  while read -r OUTPUT 
  do
    stringarray=($OUTPUT)

    indexname=${stringarray[0]}
    indexdate=${stringarray[1]}
    echo "indexname: $indexname, indexdate: $indexdate"
    if [ $indexdate -lt $TWOWEEKMARK ]; then        
        delete_indices=false
        echo ""
        echo "Index $indexname older than 2 weeks. Archiving....."
        echo ""
        curl -XPUT -s ${ES_URL}/_snapshot/${ES_REPO}/$indexname?wait_for_completion=true -d '{ "indices": "'"$indexname"'", "ignore_unavailable": true, "include_global_state": false}' -H "${json_header}"
        echo ""

        current_backup=$(curl -s ${ES_URL}/_snapshot/${ES_REPO}/$indexname)
        if [[ $current_backup = *'"state":"SUCCESS"'* ]]; then
            delete_indices=true
        fi

        if [ "$delete_indices" = true ]; then
            echo "$indexname has been archived. deleting..."
            delete_indices=false
            #curl -XDELETE ${ES_URL}/$indexname
        fi
    fi
  done <<< "$indices"
else
  curl -XGET "${ES_URL}/_snapshot/${ES_REPO}/${snapshot_option}" -H "${json_header}"
fi

