#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_config
#
# Copyright:: 2018, BaritoLog.
#
#



Chef::Recipe.send(:include, HostProperties)
hostname = node.hostname
port = node['elasticsearch']['port']
bulk_queue_size = node['elasticsearch']['bulk_queue_size']
auto_create_index = node['elasticsearch']['auto_create_index']
data_dir = node['elasticsearch']['data_directory']
node_master = node['elasticsearch']['node_master']
node_member = node['elasticsearch']['node_member']
cluster_name = node['elasticsearch']['cluster_name']
jvm_options = node['elasticsearch']['jvm_options'].map do |key, opt|
  "#{key}#{"=#{opt}" unless opt.to_s.empty?}" unless opt == 'nil'
end
member_hosts = node['elasticsearch']['member_hosts']

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
config = {
  'path.data' => data_dir,
  'node.name' => hostname,
  'http.port' => port,
  'network.host' => hostname,
  'bootstrap.memory_lock' => false,
  'thread_pool.bulk.size' => bulk_size_conf,
  'thread_pool.bulk.queue_size' => bulk_queue_size,
  'action.auto_create_index' => auto_create_index,
}

if node_master
  config['cluster.name'] = cluster_name
  config['node.master'] = node_master
  config['discovery.zen.ping.unicast.hosts'] = member_hosts
  config['network.host'] = node.ipaddress
elsif node_member
  config['cluster.name'] = cluster_name
  config['node.data'] = node_member
  config['network.host'] = node.ipaddress
else
  config['network.host'] = hostname
end

elasticsearch_configure 'elasticsearch' do
  allocated_memory elasticsearch_memory
  jvm_options jvm_options
  configuration (config)
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

# Start elasticsearch
include_recipe "#{cookbook_name}::elasticsearch_systemd"

number_of_replicas = node['elasticsearch']['index_number_of_replicas']

# Since ES >= 5, index configuration cannot using yaml file, using dynamic config API instead

# Create default template which will used by future indices with default number_of_replicas
http_request 'Create default template' do
  url "http://#{node.ipaddress}:#{port}/_template/default"
  action :put
  headers "Content-Type" => "application/json"
  message "{ \"index_patterns\": [\"*\"], \"order\": -1, \"settings\": { \"number_of_replicas\": \"#{number_of_replicas}\" }}"
  retry_delay 30
  retries 10
end

# Update old index, might be error because new node have empty index, ignored
http_request 'Change number_of_replicas in existing index' do
  url "http://#{node.ipaddress}:#{port}/_settings"
  action :put
  headers "Content-Type" => "application/json"
  message "{ \"number_of_replicas\" : \"#{number_of_replicas}\" }"
  retry_delay 30
  ignore_failure true
end