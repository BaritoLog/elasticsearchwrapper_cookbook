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
default['elasticsearch']['version'] = '6.4.1'
default['elasticsearch']['port'] = 9200
default['elasticsearch']['auto_create_index'] = true
default['elasticsearch']['data_directory'] = '/var/lib/elasticsearch'
default['elasticsearch']['bulk_queue_size'] = 1000
default['elasticsearch']['allocated_memory'] = nil
default['elasticsearch']['max_allocated_memory'] = 30500000
default['elasticsearch']['heap_mem_percent'] = 50
default['elasticsearch']['node_master'] = false
default['elasticsearch']['node_member'] = true
default['elasticsearch']['cluster_name'] = "elasticsearch"
default['elasticsearch']['member_hosts'] = []

# Java package to install by platform
default['elasticsearch']['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-11-jdk-headless'
}

# Attributes for registering this service to consul
default['elasticsearch']['consul']['config_dir'] = '/opt/consul/etc'
default['elasticsearch']['consul']['bin'] = '/opt/bin/consul'
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
  '-XX:UseAVX=2'
}
