include_recipe 'apt'

package [
  "nginx-light",
  "php7.0",
  "php7.0-fpm",
  # todo move all these packages into seperate files.
  # this one is required for databases.rb
  "build-essential",
  "mariadb-server-10.0",
  "mariadb-client-10.0",
  "libmysqlclient-dev",
  "nodejs",
  "dnsmasq",
  "git",
  "rsync",
  "curl",
  "patchutils",
  "siege",
  "imagemagick",
  # Add my packages
  "mc",
  "tmux",
  "php7.0-bcmath",
] do
  action :install
end

service "php7.0-fpm" do
    supports :start => true, :stop => true, :restart => true, :reload => true
    action [ :enable, :start ]
end

# service "mysql" do
#     supports :start => true, :stop => true, :restart => true, :reload => true
#     action [ :enable, :start ]
# end

##
# TODO:
# release blockers: persistant storage.
# should: pimpmylogs, syslog, ssl, tika, xhprof/webgrind
# could: (in another role?): mongo, phpmyadmin, vdd.json in the project root, Apache, uploadprogress, varnish, vimconfig
#
#
# "something_else":[
#
#   "recipe[varnish_ng]",
#   "recipe[php5-fpm]",
#
#   "recipe[solr]",
#   "recipe[mariadb::default]",
#   "recipe[mongodb3]",
#
#   "recipe[vim_config]",
#
#   "recipe[nodejs]",
#   "recipe[nodejs::npm]",
#
#   "recipe[memcached]",
#   "recipe[imagemagick]"
#
#   "recipe[dnsmasq]","recipe[phantomjs]",
#
#   "recipe[apache2] We're not even thinking it's that important. I don't miss it.",
#   "recipe[nginx] this one worked before I thought",
#   "recipe[vdd::apache]",
#   "recipe[vdd::graphviz]",
#   "recipe[vdd::mysql]",
#   "recipe[vdd::sites]",
#   "recipe[vdd::databases]",
#   "recipe[vdd::php]",
#   "recipe[vdd::uploadprogress]",
#   "recipe[vdd::mailcatcher]",
#   "recipe[vdd::phpmyadmin]",
#   "recipe[vdd::git]",
#   "recipe[vdd::webgrind]",
#   "recipe[vdd::mc]",
#   "recipe[vdd::rsync]",
#   "recipe[vdd::curl]",
#   "recipe[vdd::composer]",
#   "recipe[vdd::drush]",
#   "recipe[vdd::help]",
#   "recipe[vdd::vim]",
#   "recipe[vdd::patchutils]",
#   "recipe[vdd::siege]",
#   "recipe[vdd::solr]",
#   "recipe[vdd::dnsmasq]",
#   "recipe[vdd::grunt]",
#   "recipe[vdd::mongodb]",
#   "recipe[vdd::varnish]",
#   "recipe[vdd::ssl]",
#   "recipe[vdd::nginx]",
#   "recipe[vdd::bash]",
#   "recipe[vdd::pimpmylogs]",
#   "recipe[vdd::phpmongodb]",
#   "recipe[vdd::phantomjs]",
#   "recipe[vdd::drupalextension]",
#   "recipe[vdd::rsyslog]",
#   "recipe[vdd::tika]",
#   "recipe[vdd::xhprof]"
# ],
