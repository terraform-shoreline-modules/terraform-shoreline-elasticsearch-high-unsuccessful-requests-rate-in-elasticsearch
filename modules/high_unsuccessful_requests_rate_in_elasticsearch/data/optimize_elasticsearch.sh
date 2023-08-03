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