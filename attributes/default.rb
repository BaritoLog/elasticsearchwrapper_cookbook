#
# Cookbook:: elasticsearchwrapper
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'elasticsearch_wrapper_cookbook'

# User of elasticsearch process
default[cookbook_name]['user'] = 'elasticsearch'

# Elasticsearch configuration
default[cookbook_name]['port'] = 9200
default[cookbook_name]['auto_create_index'] = true
default[cookbook_name]['data_directory'] = '/var/lib/elasticsearch'
default[cookbook_name]['bulk_queue_size'] = 1000
default[cookbook_name]['allocated_memory'] = nil
default[cookbook_name]['max_allocated_memory'] = 30500000
default[cookbook_name]['heap_mem_percent'] = 50

# Java package to install by platform
default[cookbook_name]['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-11-jdk-headless'
}

# Attributes for registering this service to consul
default[cookbook_name]['consul']['config_dir'] = '/opt/consul/etc'
default[cookbook_name]['consul']['bin'] = '/opt/bin/consul'
default[cookbook_name]['package_retries'] = nil

# JVM configuration
# {key => value} which gives "key=value" or just "key" if value is nil
default[cookbook_name]['jvm_options'] = {
  '-Xss1m' => '',
  '-XX:+UseConcMarkSweepGC' => '',
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
  '-Djava.io.tmpdir' => '/tmp'
}