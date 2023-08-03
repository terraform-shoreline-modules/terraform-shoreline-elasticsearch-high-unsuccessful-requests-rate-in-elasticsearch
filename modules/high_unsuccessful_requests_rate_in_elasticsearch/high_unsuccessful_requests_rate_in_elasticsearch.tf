resource "shoreline_notebook" "high_unsuccessful_requests_rate_in_elasticsearch" {
  name       = "high_unsuccessful_requests_rate_in_elasticsearch"
  data       = file("${path.module}/data/high_unsuccessful_requests_rate_in_elasticsearch.json")
  depends_on = [shoreline_action.invoke_short_name_get_unsuccessful_rate,shoreline_action.invoke_monitor_system_stats,shoreline_action.invoke_check_index_shard_corruption,shoreline_action.invoke_optimize_elasticsearch,shoreline_action.invoke_configure_caching]
}

resource "shoreline_file" "short_name_get_unsuccessful_rate" {
  name             = "short_name_get_unsuccessful_rate"
  input_file       = "${path.module}/data/short_name_get_unsuccessful_rate.sh"
  md5              = filemd5("${path.module}/data/short_name_get_unsuccessful_rate.sh")
  description      = "ElasticSearch cluster is overloaded and unable to handle the incoming requests, leading to high unsuccessful request rates."
  destination_path = "/agent/scripts/short_name_get_unsuccessful_rate.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "monitor_system_stats" {
  name             = "monitor_system_stats"
  input_file       = "${path.module}/data/monitor_system_stats.sh"
  md5              = filemd5("${path.module}/data/monitor_system_stats.sh")
  description      = "The ElasticSearch cluster may be experiencing issues with memory or disk space, causing requests to fail and resulting in high unsuccessful request rates."
  destination_path = "/agent/scripts/monitor_system_stats.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_index_shard_corruption" {
  name             = "check_index_shard_corruption"
  input_file       = "${path.module}/data/check_index_shard_corruption.sh"
  md5              = filemd5("${path.module}/data/check_index_shard_corruption.sh")
  description      = "ElasticSearch indices or shards may have become corrupted or damaged, leading to frequent unsuccessful requests and high unsuccessful request rates."
  destination_path = "/agent/scripts/check_index_shard_corruption.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "optimize_elasticsearch" {
  name             = "optimize_elasticsearch"
  input_file       = "${path.module}/data/optimize_elasticsearch.sh"
  md5              = filemd5("${path.module}/data/optimize_elasticsearch.sh")
  description      = "Optimize the ElasticSearch cluster to improve its performance and reduce the number of unsuccessful requests."
  destination_path = "/agent/scripts/optimize_elasticsearch.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "configure_caching" {
  name             = "configure_caching"
  input_file       = "${path.module}/data/configure_caching.sh"
  md5              = filemd5("${path.module}/data/configure_caching.sh")
  description      = "Implement caching mechanisms to reduce the number of requests being made to ElasticSearch. This may involve"
  destination_path = "/agent/scripts/configure_caching.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_short_name_get_unsuccessful_rate" {
  name        = "invoke_short_name_get_unsuccessful_rate"
  description = "ElasticSearch cluster is overloaded and unable to handle the incoming requests, leading to high unsuccessful request rates."
  command     = "`chmod +x /agent/scripts/short_name_get_unsuccessful_rate.sh && /agent/scripts/short_name_get_unsuccessful_rate.sh`"
  params      = ["ELASTICSEARCH_HOST","THRESHOLD"]
  file_deps   = ["short_name_get_unsuccessful_rate"]
  enabled     = true
  depends_on  = [shoreline_file.short_name_get_unsuccessful_rate]
}

resource "shoreline_action" "invoke_monitor_system_stats" {
  name        = "invoke_monitor_system_stats"
  description = "The ElasticSearch cluster may be experiencing issues with memory or disk space, causing requests to fail and resulting in high unsuccessful request rates."
  command     = "`chmod +x /agent/scripts/monitor_system_stats.sh && /agent/scripts/monitor_system_stats.sh`"
  params      = ["PATH_TO_ELASTICSEARCH_LOGS"]
  file_deps   = ["monitor_system_stats"]
  enabled     = true
  depends_on  = [shoreline_file.monitor_system_stats]
}

resource "shoreline_action" "invoke_check_index_shard_corruption" {
  name        = "invoke_check_index_shard_corruption"
  description = "ElasticSearch indices or shards may have become corrupted or damaged, leading to frequent unsuccessful requests and high unsuccessful request rates."
  command     = "`chmod +x /agent/scripts/check_index_shard_corruption.sh && /agent/scripts/check_index_shard_corruption.sh`"
  params      = ["ELASTICSEARCH_HOST","SHARD_NUMBER","INDEX_NAME"]
  file_deps   = ["check_index_shard_corruption"]
  enabled     = true
  depends_on  = [shoreline_file.check_index_shard_corruption]
}

resource "shoreline_action" "invoke_optimize_elasticsearch" {
  name        = "invoke_optimize_elasticsearch"
  description = "Optimize the ElasticSearch cluster to improve its performance and reduce the number of unsuccessful requests."
  command     = "`chmod +x /agent/scripts/optimize_elasticsearch.sh && /agent/scripts/optimize_elasticsearch.sh`"
  params      = ["ELASTICSEARCH_CONFIG","ELASTICSEARCH_PATH"]
  file_deps   = ["optimize_elasticsearch"]
  enabled     = true
  depends_on  = [shoreline_file.optimize_elasticsearch]
}

resource "shoreline_action" "invoke_configure_caching" {
  name        = "invoke_configure_caching"
  description = "Implement caching mechanisms to reduce the number of requests being made to ElasticSearch. This may involve"
  command     = "`chmod +x /agent/scripts/configure_caching.sh && /agent/scripts/configure_caching.sh`"
  params      = ["ELASTICSEARCH_HOST","CACHE_TIME"]
  file_deps   = ["configure_caching"]
  enabled     = true
  depends_on  = [shoreline_file.configure_caching]
}

