#
# Cookbook Name:: amy_wp
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

include_recipe 'mysql-multi::default'
include_recipe 'mysql-multi::mysql_slave'
include_recipe 'wp::lbaas-slave'
