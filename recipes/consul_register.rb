#
# Cookbook:: elasticsearchwrapper
# Recipe:: consul_register
#
# Copyright:: 2018, BaritoLog.
#
#

config = {
  "id": "#{node['hostname']}-elasticsearch",
  "name": "elasticsearch",
  "tags": ["app:"],
  "address": node['ipaddress'],
  "port": node['elasticsearch']['port'],
  "meta": {
    "http_schema": "http"
  }
}

consul_register_service "elasticsearch" do
  config config
  config_dir  node[cookbook_name]['consul']['config_dir']
  consul_bin  node[cookbook_name]['consul']['bin']
end
