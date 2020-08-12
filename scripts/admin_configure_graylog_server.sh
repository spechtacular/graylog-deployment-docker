#!/bin/bash
# run as admin user
if [ "$(whoami)" != "administrator" ]; then
        echo "Script must be run as user: administrator"
        exit -1
fi

crontab ./crontabs/administrator

