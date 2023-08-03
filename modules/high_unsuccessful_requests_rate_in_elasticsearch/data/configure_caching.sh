
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