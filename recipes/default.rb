Chef::Recipe.send(:include, HostProperties)

# Java is needed by elasticsearch, can install it with package
java = node['elasticsearch']['java']
# java installation can be intentionally ignored by setting the whole key to ''
unless java.to_s.empty?
  java_package = java[node['platform']]

  if java_package.to_s.empty?
    Chef::Log.warn  "No java specified for the platform #{node['platform']}, "\
                    'java will not be installed'

    Chef::Log.warn  'Please specify a java package name if you want to '\
                    'install java using this cookbook.'
  else
    package_retries = node['elasticsearch']['package_retries']
    package java_package do
      retries package_retries unless package_retries.nil?
    end
  end
end

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

if node['elasticsearch']['allocated_memory']
  elasticsearch_memory = "#{node['elasticsearch']['allocated_memory']/1024}m"
else
  elasticsearch_memory = allocated_memory
end

bulk_size_conf = bulk_size
elasticsearch_configure 'elasticsearch' do
  allocated_memory elasticsearch_memory
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
    'bootstrap.memory_lock' => false,
    'thread_pool.bulk.size' => bulk_size_conf,
    'thread_pool.bulk.queue_size' => bulk_queue_size,
    'action.auto_create_index' => auto_create_index
  })
  action :manage
end

# TODO: this is not working, should be refactored
# limits_config 'elasticsearch' do
#   limits [
#     { domain: 'elasticsearch', type: 'hard', value: 'unlimited', item: 'memlock' },
#     { domain: 'elasticsearch', type: 'soft', value: 'unlimited', item: 'memlock' }
#   ]
# end

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
