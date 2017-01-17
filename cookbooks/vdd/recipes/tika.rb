directory "/opt/apache-tika" do
  mode  00755
  action :create
  recursive true
end

remote_file '/opt/apache-tika/tika.jar' do
  source 'http://archive.apache.org/dist/tika/tika-app-1.13.jar'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
