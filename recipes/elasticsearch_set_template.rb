#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_set_template
#
# Copyright:: 2018, BaritoLog.
#
#
require 'json'
version = node['elasticsearch']['version']
ipaddress = node['ipaddress']
port = node['elasticsearch']['port']
xpack_enabled = node['elasticsearch']['security']['xpack_security_enabled']
bootstrap_password = Base64.decode64(node['elasticsearch']['security']['bootstrap_password'])
override_base_template = node['elasticsearch']['override_base_template']
basic_auth = Base64.encode64("elastic:#{bootstrap_password}")
use_cluster_ip = node['elasticsearch']['use_cluster_ip']
cluster_ip = node['elasticsearch']['cluster_ip']

if use_cluster_ip
  es_ip = cluster_ip
else
  es_ip = "#{ipaddress}:#{port}"
end

if override_base_template
  base_template = node['elasticsearch']['base_template']
elsif version >= '6.0.0' && version < '7.0.0'
  base_template = node['elasticsearch']['base_template_es6']
elsif version >= '7.0.0' && version < '8.0.0'
  base_template = node['elasticsearch']['base_template_es7']
else
  base_template = node['elasticsearch']['base_template']
end


if xpack_enabled
  http_request 'Create base template' do
    url "http://#{es_ip}/_template/base_template"
    action :put
    headers({'AUTHORIZATION' => "Basic #{basic_auth}",
      'Content-Type' => 'application/json'
    })
    message(base_template.to_json)
    retries 10
    retry_delay 30
    ignore_failure true
  end
else
  http_request 'Create base template' do
    url "http://#{es_ip}/_template/base_template"
    action :put
    headers 'Content-Type' => 'application/json'
    message(base_template.to_json)
    retries 10
    retry_delay 30
    ignore_failure true
  end
end