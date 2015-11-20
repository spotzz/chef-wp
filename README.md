Overview
========

This chef repo contains all you need to create a mysql master/slave replication setup and add it to a pre-configured Rackspace loadbalancer. It will also create 2 nodes running apache with Wordpress which will be added and enabled into a pre-configured lbaas instance.

Given more time, data bags should be encrypted but due to limited time for development and QE it is not addressed in this cookbook nor is configuring firewalls.

Repository Directories
======================

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `cookbooks/` - Cookbooks you download or create.
* `data_bags/` - Store data bags and items in .json in the repository.
* `roles/` - Store roles in .rb or .json in the repository.
* `environments/` - Store environments in .rb or .json in the repository.

Configuration
=============

The repository contains a knife configuration file.

* .chef/knife.rb

The knife configuration file `.chef/knife.rb` is a repository specific configuration file for knife. If you're using Hosted Chef, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`. For more information about configuring Knife, see the Knife documentation.

https://docs.chef.io/knife.html

Next Steps
==========

Read the README file in each of the subdirectories for more information about what goes in those directories.
=======
You will need to put you chef and rackspace credentials in the knife.rb file as well as create the lbaas instances for web (port 80) and the databases (port 3306) which need to be configured in the lbaas-creds cloud data bag. The DB slave will not be enabled as it is for backups and manual failover. The DB lbaas IP as well as the desired database passwords need to be set in attributes/default.rb

The following make up the contents of the doit.sh file which can be run to set up the initial 2 DB and 2 Web nodes

#/bin/bash
#build the nodes
knife rackspace server create --server-name db1 --node-name db1 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 4 --ssh-keypair knife
knife rackspace server create --server-name db2 --node-name db2 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 4 --ssh-keypair knife
knife rackspace server create --server-name wp1 --node-name wp1 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 3 --ssh-keypair knife
knife rackspace server create --server-name wp2 --node-name wp2 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 3 --ssh-keypair knife

#tag the dbs
knife tag create db1 mysql_master
knife tag create db2 mysql_slave

--------------
Once the images are created the nodes need to be bootstrapped in the following order

knife bootstrap <db1 IP> --run-list 'recipe[wp::mysql_master]'
knife bootstrap <db2 IP> --run-list 'recipe[wp::mysql_slave]'
knife bootstrap <db1 IP> --run-list 'recipe[wp::wp_mysql]'
knife bootstrap <wp1 IP> --run-list 'recipe[wp::wp_web]'
knife bootstrap <wp2 IP> --run-list 'recipe[wp::wp_web]'


