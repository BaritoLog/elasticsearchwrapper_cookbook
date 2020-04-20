#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_set_template
#
# Copyright:: 2018, BaritoLog.
#
#
version = node['elasticsearch']['version']
ipaddress = node['ipaddress']

if version >= '6.0.0' && version < '7.0.0'
  base_template = defined?(node['elasticsearch']['base_template']) ? node['elasticsearch']['base_template'] : node['elasticsearch']['base_template_es6']
elsif version >= '7.0.0' && version < '8.0.0'
  base_template = defined?(node['elasticsearch']['base_template']) ? node['elasticsearch']['base_template'] : node['elasticsearch']['base_template_es7']
else
  base_template = node['elasticsearch']['base_template']
end

port = node['elasticsearch']['port']

http_request 'Create base template' do
  url "http://#{ipaddress}:#{port}/_template/base_template"
  action :put
  headers "Content-Type" => "application/json"
  message "#{base_template}"
  retry_delay 30
  retries 10
end