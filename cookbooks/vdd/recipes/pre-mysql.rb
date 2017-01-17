directory "/mnt/persistant/mysql" do
  action :create
end

link "/var/lib/mysql" do
  to "/mnt/persistant/mysql"
end

service "apparmor" do
  supports :restart => true, :start => true, :stop => true
  action :nothing
end

template "/etc/apparmor.d/tunables/alias" do
  source "apparmor.alias.erb"
  notifies :restart, "service[apparmor]"
end
