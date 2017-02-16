pkgs = [
  "php-gd",
  "php-mysql",
  "php-mcrypt",
  "php-curl",
  "php-sqlite3",
  "php-mongodb",
  "php-imagick",
  "php-xdebug",
  "php-memcache",
  "php-zip",
  "php-xml",
]

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/php/7.0/mods-available/vdd_php.ini" do
  source "php/vdd_php.ini.erb"
  mode "0644"
  notifies :restart, "service[php7.0-fpm]", :delayed
end

execute 'phpenmod' do
  command "phpenmod vdd_php"
end

template "/etc/php/7.0/mods-available/xdebug_http.ini" do
  source "php/xdebug.ini.erb"
  mode "0644"
  notifies :restart, "service[php7.0-fpm]", :delayed
end

execute 'phpenmod' do
  command "phpenmod xdebug_http -s fpm"
end

template "/etc/php/7.0/mods-available/xdebug_cli.ini" do
  source "php/xdebug-cli.ini.erb"
  mode "0644"
end

# Leaving this off as I suspect it breaks things.
# execute 'phpenmod' do
#   command "phpenmod xdebug_http -s cli"
# end
