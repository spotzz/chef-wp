#/bin/bash
#build the nodes
knife rackspace server create --server-name db1 --node-name db1 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 4 --ssh-keypair knife
knife rackspace server create --server-name db2 --node-name db2 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 4 --ssh-keypair knife
knife rackspace server create --server-name wp1 --node-name wp1 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 3 --ssh-keypair knife
knife rackspace server create --server-name wp2 --node-name wp2 --image 09de0a66-3156-48b4-90a5-1cf25a905207 --flavor 3 --ssh-keypair knife

#tag the dbs
knife tag create db1 mysql_master
knife tag create db2 mysql_slave

