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

# Create the settings for xdebug in HTTP.
template "/etc/php/7.0/mods-available/xdebug_http.ini" do
  source "php/xdebug_http.ini.erb"
  mode "0644"
  notifies :restart, "service[php7.0-fpm]", :delayed
end

# Create the settings for xdebug in CLI.
template "/etc/php/7.0/mods-available/xdebug_cli.ini" do
  source "php/xdebug_cli.ini.erb"
  mode "0644"
end

execute 'configure_xdebug' do
  # Enable the generic xdebug config (This is just the module file inclusion).
  command "phpenmod xdebug"

  # Enable HTTP xdebug settings for FPM only.
  command "phpenmod -s fpm xdebug_http"
  command "phpdismod -s cli xdebug_http"

  # Enable CLI xdebug settings for CLI only.
  command "phpenmod -s cli xdebug_cli"
  command "phpdismod -s fpm xdebug_cli"
end
