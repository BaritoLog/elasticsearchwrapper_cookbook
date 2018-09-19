#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_config
#
# Copyright:: 2018, BaritoLog.
#
#



Chef::Recipe.send(:include, HostProperties)
hostname = node.hostname
port = node[cookbook_name]['port']
bulk_queue_size = node[cookbook_name]['bulk_queue_size']
auto_create_index = node[cookbook_name]['auto_create_index']
data_dir = node[cookbook_name]['data_directory']
node_master = node[cookbook_name]['node_master']
node_member = node[cookbook_name]['node_member']
jvm_options = node[cookbook_name]['jvm_options'].map do |key, opt|
  "#{key}#{"=#{opt}" unless opt.to_s.empty?}" unless opt == 'nil'
end
member_hosts = node[cookbook_name]['member_hosts']

directory data_dir do
  owner user
  group user
  action :create
end

if node[cookbook_name]['allocated_memory']
  elasticsearch_memory = "#{node[cookbook_name]['allocated_memory']/1024}m"
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
  config['node.master'] = node_master
  config['discovery.zen.ping.unicast.hosts'] = member_hosts
end

config['node.data'] = node_member if node_member

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
