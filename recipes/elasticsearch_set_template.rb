#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_set_template
#
# Copyright:: 2018, BaritoLog.
#
#
version = node['elasticsearch']['version']
ipaddress = node['ipaddress']
bootstrap_password = node['elasticsearch']['bootstrap_password']
basic_auth = Base64.encode64("elastic:#{bootstrap_password}")

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
  headers({'AUTHORIZATION' => "Basic #{basic_auth}",
    'Content-Type' => 'application/json'
  })
  message base_template.to_json
  ignore_failure true
  retry_delay 30
  retries 10
end