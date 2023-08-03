

#!/bin/bash



# Check memory usage

MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%\n", $3*100/$2 }')

echo "Memory usage: $MEMORY_USAGE"



# Check disk usage

DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%s\n", $5}')

echo "Disk usage: $DISK_USAGE"



# Check ElasticSearch logs for errors

ELASTICSEARCH_LOG_PATH=${PATH_TO_ELASTICSEARCH_LOGS}

ERRORS=$(grep -i "error" $ELASTICSEARCH_LOG_PATH)

if [ -z "$ERRORS" ]

then

  echo "No errors in ElasticSearch logs"

else

  echo "Errors found in ElasticSearch logs: $ERRORS"

fi