group 'www-data' do
  action :modify
  members 'ubuntu'
  append true
end


node["vdd"]["sites"].each do |index, site|
  site_type = site["type"] || "drupal7"

  drupal_sub_folder = ""

  if !site["vhost"]["drupal_sub_folder"].nil? then
    drupal_sub_folder = site["vhost"]["drupal_sub_folder"]
    if drupal_sub_folder[0..0] != "/" then
      drupal_sub_folder = "/" + drupal_sub_folder
    end
  end

  directory "/var/www/settings/#{index}" do
    mode  00777
    action :create
    recursive true
  end

  template "/var/www/settings/#{index}/settings.inc" do
    source "drupal/settings-#{site_type}.erb"
    variables(
      shortcode: index,
      drupal_sub_folder: drupal_sub_folder,
      site: site
    )
    mode 0644
  end

  ["/mnt/persistant/site-files/#{index}/public",
   "/mnt/persistant/site-files/#{index}/private"].each do |dir|
    directory dir do
      owner 'www-data'
      group 'www-data'
      mode  00775
      action :create
      recursive true
    end
  end
end
