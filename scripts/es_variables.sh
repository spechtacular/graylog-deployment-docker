# constants
json_header='Content-Type: application/json'
export ES_URL="http://localhost:9200"
export CONTAINER_NAME="elasticsearch"
export BACKUP_LOCATION="/mnt/shared/elasticsearch/"

export TIMESTAMP=$(date +'%Y%m%d%H%M%S')
export ES_REPO="esbackup"

snapshot_name=${CONTAINER_NAME}_${TIMESTAMP}

JSON_FMT='{"type": "fs", "settings":{ "location": "%s"}}'
json_data=$(printf "$JSON_FMT" "${BACKUP_LOCATION}" )
