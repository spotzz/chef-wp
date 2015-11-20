#
# Cookbook Name:: wp
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
include_recipe 'apt::default'
include_recipe "php"
include_recipe "wp::client"
include_recipe "wp::lbaas-node"
include_recipe "php::module_mysql"
include_recipe "apache2"
include_recipe "apache2::mod_php5"


::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['wordpress']['keys']['auth'] = secure_password
node.set_unless['wordpress']['keys']['secure_auth'] = secure_password
node.set_unless['wordpress']['keys']['logged_in'] = secure_password
node.set_unless['wordpress']['keys']['nonce'] = secure_password
node.set_unless['wordpress']['salt']['auth'] = secure_password
node.set_unless['wordpress']['salt']['secure_auth'] = secure_password
node.set_unless['wordpress']['salt']['logged_in'] = secure_password
node.set_unless['wordpress']['salt']['nonce'] = secure_password
node.save unless Chef::Config[:solo]

directory node['wordpress']['dir'] do
  action :create
  recursive true
  if platform_family?('windows')
    rights :read, 'Everyone'
  else
    owner node['wordpress']['install']['user']
    group node['wordpress']['install']['group']
    mode  '00755'
  end
end

archive = platform_family?('windows') ? 'wordpress.zip' : 'wordpress.tar.gz'

if platform_family?('windows')
  windows_zipfile node['wordpress']['parent_dir'] do
    source node['wordpress']['url']
    action :unzip
    not_if {::File.exists?("#{node['wordpress']['dir']}\\index.php")}
  end
else
  tar_extract node['wordpress']['url'] do
    target_dir node['wordpress']['dir']
    creates File.join(node['wordpress']['dir'], 'index.php')
    user node['wordpress']['install']['user']
    group node['wordpress']['install']['group']
    tar_flags [ '--strip-components 1' ]
    not_if { ::File.exists?("#{node['wordpress']['dir']}/index.php") }
  end
end

template "#{node['wordpress']['dir']}/wp-config.php" do
  source 'wp-config.php.erb'
  mode node['wordpress']['config_perms']
  variables(
    :db_name           => node['wordpress']['db']['name'],
    :db_user           => node['wordpress']['db']['user'],
    :db_password       => node['wordpress']['db']['pass'],
    :db_host           => node['wordpress']['db']['host'],
    :db_prefix         => node['wordpress']['db']['prefix'],
    :db_charset        => node['wordpress']['db']['charset'],
    :db_collate        => node['wordpress']['db']['collate'],
    :auth_key          => node['wordpress']['keys']['auth'],
    :secure_auth_key   => node['wordpress']['keys']['secure_auth'],
    :logged_in_key     => node['wordpress']['keys']['logged_in'],
    :nonce_key         => node['wordpress']['keys']['nonce'],
    :auth_salt         => node['wordpress']['salt']['auth'],
    :secure_auth_salt  => node['wordpress']['salt']['secure_auth'],
    :logged_in_salt    => node['wordpress']['salt']['logged_in'],
    :nonce_salt        => node['wordpress']['salt']['nonce'],
    :lang              => node['wordpress']['languages']['lang'],
    :allow_multisite   => node['wordpress']['allow_multisite'],
    :wp_config_options => node['wordpress']['wp_config_options']
  )
  owner node['wordpress']['install']['user']
  group node['wordpress']['install']['group']
  action :create
end

  web_app "wordpress" do
    template "wordpress.conf.erb"
    docroot node['wordpress']['dir']
    server_name node['wordpress']['server_name']
    server_aliases node['wordpress']['server_aliases']
    server_port node['wordpress']['server_port']
    enable true
  end
