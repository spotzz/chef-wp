mysql_client 'default' do
  action :create
end

mysql2_chef_gem 'default' do
  action :install
end
