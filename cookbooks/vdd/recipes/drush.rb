execute 'install_drush' do
  command "su ubuntu -c 'composer global require drush/drush'"
end
