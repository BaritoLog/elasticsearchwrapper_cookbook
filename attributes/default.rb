# User of elasticsearch process
default['elasticsearch']['user'] = 'elasticsearch'

# Elasticsearch configuration
default['elasticsearch']['port'] = 9200
default['elasticsearch']['auto_create_index'] = true
default['elasticsearch']['data_directory'] = '/var/lib/elasticsearch'
default['elasticsearch']['bulk_queue_size'] = 1000
default['elasticsearch']['allocated_memory'] = nil
default['elasticsearch']['max_allocated_memory'] = 30500000

# Java package to install by platform
default['elasticsearch']['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-11-jdk-headless'
}

# Attributes for registering this service to consul
default['elasticsearch']['consul']['config_dir'] = '/opt/consul/etc'
default['elasticsearch']['consul']['bin'] = '/opt/bin/consul'
