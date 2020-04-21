#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_set_replica
#
# Copyright:: 2018, BaritoLog.
#
#

number_of_shards = node['elasticsearch']['index_number_of_shards']
number_of_replicas = node['elasticsearch']['index_number_of_replicas']
refresh_interval = node['elasticsearch']['index_refresh_intervals']
port = node['elasticsearch']['port']
ipaddress = node['ipaddress']
# Since ES >= 5, index configuration cannot using yaml file, using dynamic config API instead

# Create default template which will used by future indices with default number_of_replicas
http_request 'Create default template' do
  url "http://#{ipaddress}:#{port}/_template/index_settings"
  action :put
  headers "Content-Type" => "application/json"
  message "{ \"index_patterns\": [\"*\"], \"order\": 0, \"settings\": { \"number_of_shards\": \"#{number_of_shards}\", \"number_of_replicas\": \"#{number_of_replicas}\", \"refresh_intervals\": \"#{refresh_intervals}\" }}"
  retry_delay 30
  retries 10
end

# Update old index, might be error because new node have empty index, ignored
http_request 'Change number_of_replicas in existing index' do
  url "http://#{ipaddress}:#{port}/_settings"
  action :put
  headers "Content-Type" => "application/json"
  message "{ \"number_of_shards\": \"#{number_of_shards}\", \"number_of_replicas\": \"#{number_of_replicas}\", \"refresh_interval\": \"#{refresh_intervals}\" }"
  retry_delay 30
  ignore_failure true
end
