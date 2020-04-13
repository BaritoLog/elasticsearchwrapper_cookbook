#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_set_template
#
# Copyright:: 2018, BaritoLog.
#
#

elastic_version = node['elasticsearch']['version']

if version >= '6.0.0' && version < '7.0.0' do
  base_template = defined?(node['elasticsearch']['base_template']) ? node['elasticsearch']['base_template'] : node['elasticsearch']['base_template_es6']
elsif version >= '7.0.0' && version < '8.0.0' do
  base_template = defined?(node['elasticsearch']['base_template']) ? node['elasticsearch']['base_template'] : node['elasticsearch']['base_template_es7']
else
  base_template = node['elasticsearch']['base_template']
end

port = node['elasticsearch']['port']

# Since ES >= 5, index configuration cannot using yaml file, using dynamic config API instead

# Create default template which will used by future indices with default number_of_replicas
http_request 'Create base template' do
  url "http://#{node.ipaddress}:#{port}/_template/base_default"
  action :put
  headers "Content-Type" => "application/json"
  message "#{base_template}"
  retry_delay 30
  retries 10
end