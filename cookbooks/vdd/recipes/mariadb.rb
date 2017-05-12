# Install MariaDB
include_recipe 'mariadb'

# Restart mysql service
execute "shutdown_mysql" do
  user "root"
  group "root"
  command <<-EOF
   /usr/bin/mysqladmin -u root -p#{node['mariadb']['server_root_password']} shutdown
  EOF
  notifies :restart, 'service[restart_mysql]', :immediately
end

service "restart_mysql" do
  service_name 'mysql'
  action :nothing
end