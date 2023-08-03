

#!/bin/bash



# Set Elasticsearch URL and threshold

THRESHOLD=${THRESHOLD}



# Get the high unsuccessful requests rate

RATE=$(curl -s -XGET "${ELASTICSEARCH_HOST}:9200/_nodes/stats/thread_pool" | jq '.nodes[].thread_pool.search.rejected' | awk '{s+=$1} END {print s}')



# Check if the rate is above the threshold

if [ "${RATE}" -gt "${THRESHOLD}" ]; then

  echo "High unsuccessful requests rate detected. Current rate: ${RATE}"

  # Add any additional commands to help diagnose and resolve the issue

else

  echo "Unsuccessful requests rate is within expected range. Current rate: ${RATE}"

fi