
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Unsuccessful Requests Rate in ElasticSearch
---

This incident type typically occurs when the unsuccessful requests rate in ElasticSearch is higher than the expected threshold. This may indicate that there are issues with the ElasticSearch cluster or that it is not able to handle the requests in a timely manner. To prevent further issues, it is important to investigate the root cause and address any underlying issues that may be causing the high unsuccessful requests rate. This will help ensure that the ElasticSearch cluster is able to handle requests efficiently and effectively.

### Parameters
```shell
# Environment Variables

export ELASTICSEARCH_HOST="PLACEHOLDER"

export INDEX_NAME="PLACEHOLDER"

export THRESHOLD="PLACEHOLDER"

export PATH_TO_ELASTICSEARCH_LOGS="PLACEHOLDER"

export SHARD_NUMBER="PLACEHOLDER"

export ELASTICSEARCH_PATH="PLACEHOLDER"

export ELASTICSEARCH_CONFIG="PLACEHOLDER"

export CACHE_TIME="PLACEHOLDER"
```

## Debug

### Check ElasticSearch cluster health
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/_cluster/health?pretty'
```

### Check ElasticSearch cluster state
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/_cluster/state?pretty'
```

### Check ElasticSearch cluster stats
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/_nodes/stats?pretty'
```

### Check ElasticSearch index health
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/_cat/indices?v'
```

### Check ElasticSearch index status
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/_cat/shards?v'
```

### Check ElasticSearch index settings
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/${INDEX_NAME}/_settings?pretty'
```

### Check ElasticSearch index mappings
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/${INDEX_NAME}/_mapping?pretty'
```

### Check ElasticSearch index stats
```shell
curl -XGET '${ELASTICSEARCH_HOST}:9200/${INDEX_NAME}/_stats?pretty'
```

### ElasticSearch cluster is overloaded and unable to handle the incoming requests, leading to high unsuccessful request rates.
```shell


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


```

### The ElasticSearch cluster may be experiencing issues with memory or disk space, causing requests to fail and resulting in high unsuccessful request rates.
```shell


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


```

### ElasticSearch indices or shards may have become corrupted or damaged, leading to frequent unsuccessful requests and high unsuccessful request rates.
```shell


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


```

## Repair

### Optimize the ElasticSearch cluster to improve its performance and reduce the number of unsuccessful requests.
```shell
#!/bin/bash

# Define variables

${ELASTICSEARCH_PATH}="/usr/share/elasticsearch"

${ELASTICSEARCH_CONFIG}="/etc/elasticsearch/elasticsearch.yml"

# Stop the ElasticSearch service

sudo systemctl stop elasticsearch

# Increase the memory allocation for ElasticSearch

sudo sed -i 's/-Xms1g/-Xms4g/g' ${ELASTICSEARCH_CONFIG}

sudo sed -i 's/-Xmx1g/-Xmx4g/g' ${ELASTICSEARCH_CONFIG}

# Optimize the ElasticSearch configuration

sudo sed -i 's/#bootstrap.memory_lock: true/bootstrap.memory_lock: true/g' ${ELASTICSEARCH_CONFIG}

sudo sed -i 's/#thread_pool.search.size: 5/thread_pool.search.size: 10/g' ${ELASTICSEARCH_CONFIG}

sudo sed -i 's/#thread_pool.search.queue_size: 1000/thread_pool.search.queue_size: 5000/g' ${ELASTICSEARCH_CONFIG}

# Start the ElasticSearch service

sudo systemctl start elasticsearch

sudo bash optimize_elasticsearch.sh

```

### Implement caching mechanisms to reduce the number of requests being made to ElasticSearch. This may involve
```shell

#!/bin/bash

# Set variables

CACHE_TIME=${CACHE_TIME}

# Configure caching

curl -XPUT ${ELASTICSEARCH_HOST}:9200 -d '{

    "index" : {

        "cache" : {

            "query" : {

                "enable" : true,

                "cache_count" : 10000,

                "cache_size" : "2gb",

                "expire" : "'$CACHE_TIME'"

            }

        }

    }

}'


```