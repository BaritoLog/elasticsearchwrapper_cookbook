#
# Cookbook:: kibana_wrapper
# Attribute:: default
#
# Copyright:: 2018, Pathfinder CM.
#
#

default['kibana']['version'] = '6.3.0'
default['kibana']['config']['elasticsearch.url'] = 'http://elasticsearch.service.consul:9200'
default['kibana']['config']['server.basePath'] = '/test'
default['kibana']['config']['port'] = '5601'
default['kibana']['config']['xpack.security.enabled'] = false
default['kibana']['config']['prometheus_url'] = 'http://localhost'
default['kibana']['config']['message_format'] = 'Warning: TPS exceeded on these apps: %s. Please ask app group owner to increase TPS.'
override['kibana']['config']['base_dir'] = '/opt/kibana'
override['kibana']['config']['logging.dest'] = '/var/log/kibana.log'

default['nginx']['default_site_enabled'] = false
default['nginx']['user'] = node['kibana']['service_user']
default['nginx']['kibana_path'] = '/etc/nginx/conf.d/kibana.conf'
default['nginx']['ip_address'] = '0.0.0.0'
default['nginx']['port'] = 80

# Attributes for registering this service to consul
default['kibana']['consul']['config_dir'] = '/opt/consul/etc'
default['kibana']['consul']['bin'] = '/opt/bin/consul'
default['consul']['cli_opts'] = {
  'config-dir' => default['kibana']['consul']['config_dir'],
  'enable-script-checks' => nil,
  'advertise' => node['ipaddress']
}
