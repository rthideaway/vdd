include_recipe 'vdd::ssl'
certificate_path = node["ssl"]["certificate_path"]

# execute "prep sites" do
#     command "find /etc/nginx/sites-enabled/ -delete"
#     action :run
# end

template "/etc/nginx/sites-enabled/default" do
  source "nginx/default.conf"
  manage_symlink_source false
  force_unlink true
  variables(
    certificate_path: certificate_path,
  )
end

template "/etc/nginx/snippets/vdd-php.conf" do
  source "nginx/vdd-php.conf"
end

if node["vdd"]["sites"]

  node["vdd"]["sites"].each do |index, site|

      site_type = "drupal7"

      if !site["type"].nil? then
        site_type = site["type"]
      end

      drupal_sub_folder = ""

      if !site["vhost"]["drupal_sub_folder"].nil? then
        drupal_sub_folder = site["vhost"]["drupal_sub_folder"]
        if drupal_sub_folder[0..0] != "/" then
          drupal_sub_folder = "/" + drupal_sub_folder
        end
      end

      # What's this all about then? Making your own nginx config file doesn't
      # seem like a great plan.
      if File.exists?("/var/www/vhosts/#{index}.dev/.vdd/nginx.conf")
        template "/etc/nginx/sites-enabled/#{index}.dev" do
          source "/var/www/vhosts/#{index}.dev/.vdd/nginx.conf"
          variables(
            shortcode: index,
            certificate_path: certificate_path,
            docroot: site['vhost']['document_root'],
            alias: defined?(site["vhost"]["alias"]) ? site["vhost"]["alias"].join(" ") : ""
          )
        end
      else
        template "/etc/nginx/sites-enabled/#{index}.dev" do
          source "nginx/nginx-#{site_type}-site.conf"
          variables(
            shortcode: index,
            certificate_path: certificate_path,
            docroot: site['vhost']['document_root'],
            drupal_sub_folder: drupal_sub_folder,
            alias: defined?(site["vhost"]["alias"]) ? site["vhost"]["alias"].join(" ") : ""
          )
        end
    end

  end

end

template "/etc/init/nginx-start.conf" do
  source "nginx/upstart.conf"
end

service "nginx" do
  action :restart
end
