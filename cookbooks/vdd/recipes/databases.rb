
# The default mysql root user authenticates using the unix user account.
# which means that only root can be root. But we don't want that because it
# means you can't `drush sql-cli`.
# Alternatively, we could create a drupal user. That would be better to be
# honest.
execute 'set_db_root_password' do
  command <<-CMD
    echo "UPDATE user SET plugin='' WHERE User='root'; \
    FLUSH PRIVILEGES;" | mysql -u root -p#{node['mariadb']['server_root_password']} mysql
  CMD
  notifies :restart, "service[mysql]", :delayed
end

chef_gem 'mysql2' do
  action :install
end

mysql_connection_info = {
  :host => "localhost",
  :username => "root",
  :password => node['mariadb']['server_root_password'],
}

if node["vdd"]["sites"]
  node["vdd"]["sites"].each do |index, site|
    mysql_database index do
      connection mysql_connection_info
      action :create
    end
  end
end
