#
# Cookbook Name:: amy_wp
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'wp::lbaas-master'

db = node['wordpress']['db']
socket = "/var/run/mysql-#{db['instance_name']}/mysqld.sock"

mysql_connection_info = {
    :host     => 'localhost',
    :username => 'root',
    :socket   => socket,
    :password => db['root_password']
  }

mysql_database db['name'] do
    connection  mysql_connection_info
    action      :create
end

mysql_database_user db['user'] do
    connection    mysql_connection_info
    password      db['pass']
    host          '%'
    database_name db['name']
    action        :create
end

  mysql_database_user db['user'] do
    connection    mysql_connection_info
    database_name db['name']
    privileges    [:all]
    action        :grant
  end

