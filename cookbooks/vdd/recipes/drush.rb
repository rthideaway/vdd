execute 'install_drush' do
  user 'ubuntu'
  cwd '/home/ubuntu'
  environment ({'HOME' => '/home/ubuntu', 'USER' => 'ubuntu'})
  command "composer global require drush/drush"
end
