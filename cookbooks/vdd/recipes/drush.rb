execute 'install_drush' do
  user 'vagrant'
  cwd '/home/vagrant'
  environment ({'HOME' => '/home/vagrant', 'USER' => 'vagrant'})
  command "composer global require drush/drush"
end
