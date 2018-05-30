Chef::Resource.send(:include, HostProperties)

include_recipe 'foundation::default'
include_recipe 'java'

data_dir = node['elasticsearch']['data_directory']
user = node['elasticsearch']['user']
version = node['elasticsearch']['version']
hostname = node.hostname
port = node['elasticsearch']['port']
bulk_queue_size = node['elasticsearch']['bulk_queue_size']
auto_create_index = node['elasticsearch']['auto_create_index']

elasticsearch_user user do
  action :create
end

elasticsearch_install 'elasticsearch' do
  type 'package'
  version version
  action :install
end

directory data_dir do
  owner user
  group user
  action :create
end

elasticsearch_configure 'elasticsearch' do
  allocated_memory allocated_memory
  jvm_options %w[
    -Xss1m
    -XX:+UseConcMarkSweepGC
    -XX:CMSInitiatingOccupancyFraction=75
    -XX:+UseCMSInitiatingOccupancyOnly
    -XX:+DisableExplicitGC
    -XX:+AlwaysPreTouch
    -server
    -Djava.awt.headless=true
    -Dfile.encoding=UTF-8
    -Djna.nosys=true
    -Dio.netty.noUnsafe=true
    -Dio.netty.noKeySetOptimization=true
    -Dlog4j.shutdownHookEnabled=false
    -Dlog4j2.disable.jmx=true
    -Dlog4j.skipJansi=true
    -XX:+HeapDumpOnOutOfMemoryError
    -Djava.io.tmpdir=/tmp
  ]
  configuration ({
    'path.data' => data_dir,
    'node.name' => hostname,
    'http.port' => port,
    'network.host' => hostname,
    'bootstrap.memory_lock' => true,
    'thread_pool.bulk.size' => bulk_size,
    'thread_pool.bulk.queue_size' => bulk_queue_size,
    'action.auto_create_index' => auto_create_index
  })
  action :manage
end

limits_config 'elasticsearch' do
  limits [
    { domain: 'elasticsearch', type: 'hard', value: 'unlimited', item: 'memlock' },
    { domain: 'elasticsearch', type: 'soft', value: 'unlimited', item: 'memlock' }
  ]
end

sysctl 'vm.max_map_count' do
  key 'vm.max_map_count'
  value 262_144
  action :apply
end

link '/usr/share/elasticsearch/config' do
  to '/etc/elasticsearch/'
end

elasticsearch_service 'elasticsearch' do
  service_actions %i[start enable restart]
end

# systemd
# logrotate
