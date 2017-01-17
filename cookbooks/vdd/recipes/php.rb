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

# template "/etc/php5/mods-available/xdebug.ini" do
#   source "php/xdebug.ini.erb"
#   mode "0644"
#   notifies :restart, "service[apache2]", :delayed
#   notifies :restart, "service[php5-fpm]", :delayed
# end
# template "/etc/php5/mods-available/xdebug-cli.ini" do
#   source "php/xdebug-cli.ini.erb"
#   mode "0644"
#   notifies :restart, "service[apache2]", :delayed
#   notifies :restart, "service[php5-fpm]", :delayed
# end

phptypes = [
  "apache2",
  "cli",
  "fpm"
]

modules = [
  "vdd_php",
  "uploadprogress",
  "pdo_mysql",
  "mongo",
  "memcache",
  "sqlite3",
  "mcrypt",
  "imagick",
  "xhprof"
]

# modules.each do |mod|
#   bash "enable_php_module_#{mod}" do
#     user "root"
#     code <<-EOH
#     php5enmod #{mod}
#     EOH
#     only_if { File.exists?("/etc/php5/mods-available/#{mod}.ini") }
#   end
# end

# We want a different xdebug config for cli than for everything else
# so do this using link rather than php5enmod.
# link '/etc/php5/fpm/conf.d/20-xdebug.ini' do
#   to '/etc/php5/mods-available/xdebug.ini'
# end

# link '/etc/php5/cli/conf.d/20-xdebug.ini' do
#   to '/etc/php5/mods-available/xdebug-cli.ini'
# end
