

#!/bin/bash



# Set variables

index=${INDEX_NAME}

shard=${SHARD_NUMBER}


# Check if index exists

index_exists=$(curl -s -o /dev/null -w "%{http_code}" -XHEAD http://${ELASTICSEARCH_HOST}:9200/$index)



if [ $index_exists -eq 200 ]; then

  echo "Index $index exists."

else

  echo "Index $index does not exist."

  exit 1

fi

# Check if shard is corrupted

shard_info=$(curl -s -XGET http://${ELASTICSEARCH_HOST}:9200/$index/_shard/$shard/_stats)

if echo $shard_info | grep -q "\"corrupted\":true"; then

  echo "Shard $shard in index $index is corrupted."

  exit 1

else

  echo "Shard $shard in index $index is not corrupted."

fi