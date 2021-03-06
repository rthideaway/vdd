git "/opt/pimpmylogs" do
    repository "https://github.com/potsky/PimpMyLog"
    revision node["pimpmylogs"]["version"]
    action :sync
end

template "/opt/pimpmylogs/config.user.php" do
  source "pimpmylogs/config.user.php"
  mode 0644
end

execute "chown-data-www" do
  command "chown -R www-data:www-data /opt/pimpmylogs"
  user "root"
  action :run
end

certificate_path = node["ssl"]["certificate_path"]

cert = ssl_certificate "ssl_nginx_pimpmylogs" do
  cert_source "self-signed"
  cert_path "#{certificate_path}/crts/logs.crt"
  key_source "self-signed"
  key_path  "#{certificate_path}/keys/logs.key"
  common_name "logs.dev" + node["vm"]["domain_suffix"]
  country "uk"
  city "canterbury"
  state "kent"
  organization"deeson"
  department "drupal"
  email "drupal@drupal7."  + node["vm"]["domain_suffix"]
  years 10
end

template "/etc/nginx/sites-enabled/logs.dev" do
  source "pimpmylogs/nginx.conf.erb"
  variables(
    certificate_path: certificate_path,
  )
end

directory "/var/log/nginx" do
  mode  00777
  action :create
  recursive true
end

file '/var/log/php7.0-fpm.log' do
  mode '0664'
  owner 'www-data'
  group 'www-data'
end

file '/var/log/nginx/access.log' do
  mode '0664'
  owner 'www-data'
  group 'www-data'
end

file '/var/log/nginx/error.log' do
  mode '0664'
  owner 'www-data'
  group 'www-data'
end

file '/var/log/syslog' do
  mode '0664'
  owner 'syslog'
  group 'www-data'
end

file '/var/log/drupal.log' do
  mode '0664'
  owner 'syslog'
  group 'www-data'
end

template "/etc/rsyslog.d/20-drupal.conf" do
  source "rsyslog-drupal.conf"
  mode 0644
end

service "rsyslog" do
  action :restart
end
