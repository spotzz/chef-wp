# Wordpress config

default['wordpress']['db']['root_password'] = '<mysql root password>'
default['wordpress']['db']['host'] ='<database loadbalancer IP>'
default['wordpress']['db']['instance_name'] = 'default'
default['wordpress']['db']['pass'] = '<wordpress db password>'
default['wordpress']['db']['user'] = '<wordpress user>'

# Mysql - Multi

default['mysql-multi']['server_repl_password'] = '<replication password>'
default['mysql-multi']['service_name'] = 'default'
default['mysql-multi']['server_root_password'] = '<mysql root password>'


