#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch
#
# Copyright:: 2018, BaritoLog.
#
#

# Not doing anything on default cookbook

include_recipe "elasticsearch::elasticsearch_install"
include_recipe "elasticsearch::elasticsearch_user"
include_recipe "elasticsearch::elasticsearch_config"
include_recipe "elasticsearch::elasticsearch_systemd"


