directory "/var/www/phpmongodb" do
  mode  00777
  action :delete
  recursive true
end

git "/opt/phpmongodb" do
    repository "https://github.com/phpmongodb/phpmongodb"
    reference "master"
    action :sync
end

template "/opt/phpmongodb/config.php" do
  source "phpmongodb/config.php"
  mode 0644
end

execute "chown-data-www" do
  command "chown -R www-data:www-data /opt/phpmongodb"
  user "root"
  action :run
end

certificate_path = node["ssl"]["certificate_path"]

cert = ssl_certificate "ssl_nginx_phpmongodb" do
  cert_source "self-signed"
  cert_path "#{certificate_path}/crts/phpmongodb.crt"
  key_source "self-signed"
  key_path  "#{certificate_path}/keys/phpmongodb.key"
  common_name "phpmongodb." + node["vm"]["domain_suffix"]
  country "uk"
  city "canterbury"
  state "kent"
  organization"deeson"
  department "drupal"
  email "drupal@drupal7." + node["vm"]["domain_suffix"]
  years 10
end

template "/etc/nginx/sites-enabled/phpmongodb.conf" do
  source "phpmongodb/nginx.conf.erb"
  variables(
    certificate_path: certificate_path,
  )
end

web_app "phpmongodb" do
  template "phpmongodb/apache2.conf.erb"
end
