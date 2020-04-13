#
# Cookbook:: elasticsearchwrapper
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

# User of elasticsearch process
default['elasticsearch']['user'] = 'elasticsearch'

# Elasticsearch configuration
default['elasticsearch']['version'] = '6.3.0'
default['elasticsearch']['port'] = 9200
default['elasticsearch']['auto_create_index'] = true
default['elasticsearch']['data_directory'] = '/var/lib/elasticsearch'
default['elasticsearch']['bulk_queue_size'] = 1000
default['elasticsearch']['allocated_memory'] = nil
default['elasticsearch']['max_allocated_memory'] = 30500000
default['elasticsearch']['heap_mem_percent'] = 50
default['elasticsearch']['node_master'] = false
default['elasticsearch']['node_data'] = true
default['elasticsearch']['node_ingest'] = false
default['elasticsearch']['cluster_name'] = "elasticsearch"
default['elasticsearch']['member_hosts'] = ["http://elasticsearch.service.consul"]
default['elasticsearch']['memory_lock'] = false
default['elasticsearch']['minimum_master_nodes'] = 1
default['elasticsearch']['node_awareness_value'] = '$HOSTNAME'
default['elasticsearch']['node_awareness_attribute'] = 'hostname'

# for ES 7.x
default['elasticsearch']['initial_master_nodes'] = 'elasticsearch.service.consul'
default['elasticsearch']['discovery_seed_hosts'] = 'elasticsearch.service.consul'
default['elasticsearch']['xpack_security_enabled'] = true
default['elasticsearch']['xpack_security_transport_ssl_enabled'] = true
default['elasticsearch']['xpack_security_transport_ssl_verification_mode'] = 'certificate'
default['elasticsearch']['xpack_security_transport_ssl_keystore_path'] = 'elastic-certificates.p12'
default['elasticsearch']['xpack_security_transport_ssl_truststore_path'] = 'elastic-certificates.p12'


# Explicitly set number of replicas, override this as necessary
# Also you need to explicitly include `elasticsearch_set_replica` recipe
default['elasticsearch']['index_number_of_replicas'] = 3

# Java package to install by platform
default['elasticsearch']['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-11-jdk-headless'
}

# Attributes for registering this service to consul
default['elasticsearch']['consul']['config_dir'] = '/opt/consul/etc'
default['elasticsearch']['consul']['bin'] = '/opt/bin/consul'
default['consul']['cli_opts'] = {
  'config-dir' => default['elasticsearch']['consul']['config_dir'],
  'enable-script-checks' => nil
}
default['elasticsearch']['package_retries'] = nil

# JVM configuration
# {key => value} which gives "key=value" or just "key" if value is nil
default['elasticsearch']['jvm_options'] = {
  '-Xss1m' => '',
  '-XX:CMSInitiatingOccupancyFraction' => 75,
  '-XX:+UseCMSInitiatingOccupancyOnly' => '',
  '-XX:+DisableExplicitGC' => '',
  '-XX:+AlwaysPreTouch' => '',
  '-server' => '',
  '-Djava.awt.headless' => true,
  '-Dfile.encoding' => 'UTF-8',
  '-Djna.nosys' => true,
  '-Dio.netty.noUnsafe' => true,
  '-Dio.netty.noKeySetOptimization' => true,
  '-Dlog4j.shutdownHookEnabled' => false,
  '-Dlog4j2.disable.jmx' => true,
  '-Dlog4j.skipJansi' => true,
  '-XX:+HeapDumpOnOutOfMemoryError' => '',
  '-Djava.io.tmpdir' => '/tmp',

  # Avoid crash when using AVX-512
  # https://github.com/elastic/elasticsearch/issues/31425
  '-XX:UseAVX' => 2
}

default['elasticsearch']['base_template_es7'] = {
  "index_patterns": ["*"],
  "order": 0,
  "settings": {
    "index" : {
      "codec" : "best_compression",
      "search" : {
        "slowlog" : {
          "level" : "info",
          "threshold" : {
            "fetch" : {
              "warn" : "10s",
              "trace" : "500ms",
              "debug" : "2s",
              "info" : "5s"
            },
            "query" : {
              "warn" : "10s",
              "trace" : "500ms",
              "debug" : "2s",
              "info" : "5s"
            }
          }
        }
      },
      "number_of_shards": 3,
<<<<<<< HEAD
      "number_of_replicas": 1,
=======
>>>>>>> add template default value for es6.x and es7.x
      "refresh_interval":"30s",
      "indexing" : {
        "slowlog" : {
          "level" : "info",
          "threshold" : {
            "index" : {
              "warn" : "10s",
              "trace" : "500ms",
              "debug" : "2s",
              "info" : "5s"
            }
          },
          "source" : "1000"
        }
      },
      "translog" : {
        "durability" : "async"
      }
    }
  },
  "mappings":{
    "dynamic_templates":[
      {
        "message_field":{
          "path_match":"@message",
          "match_mapping_type":"string",
          "mapping":{
            "type":"text",
            "norms":false
          }
        }
      },
      {
        "string_fields":{
          "match":"*",
          "match_mapping_type":"string",
          "mapping":{
            "type":"text",
            "norms":false,
            "fields":{
              "keyword":{
                "type":"keyword",
                "ignore_above":256
              }
            }
          }
        }
      }
    ],
    "properties":{
      "@timestamp":{
        "type":"date"
      }
    }
  }
}

default['elasticsearch']['base_template_es6'] = {
  "index_patterns": ["*"],
  "order": 0,
  "settings": {
    "index" : {
      "codec" : "best_compression",
      "search" : {
        "slowlog" : {
          "level" : "info",
          "threshold" : {
            "fetch" : {
              "warn" : "10s",
              "trace" : "500ms",
              "debug" : "2s",
              "info" : "5s"
            },
            "query" : {
              "warn" : "10s",
              "trace" : "500ms",
              "debug" : "2s",
              "info" : "5s"
            }
          }
        }
      },
      "number_of_shards": 3,
<<<<<<< HEAD
      "number_of_replicas": 1,
=======
>>>>>>> add template default value for es6.x and es7.x
      "refresh_interval":"30s",
      "indexing" : {
        "slowlog" : {
          "level" : "info",
          "threshold" : {
            "index" : {
              "warn" : "10s",
              "trace" : "500ms",
              "debug" : "2s",
              "info" : "5s"
            }
          },
          "source" : "1000"
        }
      },
      "translog" : {
        "durability" : "async"
      }
    }
  },
  "mappings":{
    "_doc":{
      "dynamic_templates":[
        {
          "message_field":{
            "path_match":"@message",
            "match_mapping_type":"string",
            "mapping":{
              "type":"text",
              "norms":false
            }
          }
        },
        {
          "string_fields":{
            "match":"*",
            "match_mapping_type":"string",
            "mapping":{
              "type":"text","norms":false,
              "fields":{
                "keyword":{
                  "type":"keyword",
                  "ignore_above":256
                }
              }
            }
          }
        }
      ],
      "properties":{
        "@timestamp":{
          "type":"date"
        }
      }
    }
  }
}
