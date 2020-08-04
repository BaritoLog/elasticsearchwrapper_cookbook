#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_api
#
# Copyright:: 2018, BaritoLog.
#
#

# Not doing anything on default cookbook
include_recipe "#{cookbook_name}::elasticsearch_set_template"
include_recipe "#{cookbook_name}::elasticsearch_set_index_settings"
