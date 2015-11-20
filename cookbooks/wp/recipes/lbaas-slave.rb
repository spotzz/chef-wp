include_recipe "rackspace_lbaas"

local_ipv4 = node['rackspace']['local_ipv4']
require 'pp'
pp "local_ipv4=#{local_ipv4}"


creds = data_bag_item("lbaas-creds","cloud")

load_balancer_node local_ipv4 do
 username creds["rackspace_username"]
 api_key creds["rackspace_api_key"]
 load_balancer_id creds["dblbaas_id"]
 region creds["rackspace_region"]
 port 3306
 action :create
end
