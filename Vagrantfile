Vagrant.configure("2") do |config|

  # TODO if the config file doesn't exist - make it, or advise it
  config_json = JSON.parse(File.read("config.json"))
  config.vm.box = "ubuntu/xenial64"
  config.vm.network :private_network, ip: config_json["vm"]["ip"]

  # Apachesolr.
  config.vm.network "forwarded_port", guest: 8983, host: 8983, protocol: "tcp", auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", config_json["vm"]["memory"]]
    config_json["vm"]["synced_folders"].each do |folder|
      config.vm.synced_folder folder["host_path"], folder["guest_path"], type: "nfs"
      # This uses uid and gid of the user that started vagrant.
      config.nfs.map_uid = Process.uid
      config.nfs.map_gid = Process.gid
    end
  end

  unless Vagrant.has_plugin?("vagrant-persistent-storage")
    raise 'vagrant-persistent-storage is required to enable persist_db. Please install it with "vagrant plugin install vagrant-persistent-storage"'
  end

  config.persistent_storage.enabled = true
  config.persistent_storage.location = "persistant-storage.vdi"
  config.persistent_storage.size = 502400
  config.persistent_storage.mountname = 'persistant'
  config.persistent_storage.filesystem = 'ext4'
  config.persistent_storage.mountpoint = '/mnt/persistant'
  config.persistent_storage.use_lvm = false
  config.persistent_storage.diskdevice = '/dev/sdc'

  # Customize provisioner.
  config.vm.provision :chef_solo do |chef|
    chef.json = config_json
    chef.cookbooks_path = ["berks-cookbooks", "cookbooks"]
    chef.roles_path = "roles"
    chef.add_role "vdd"
  end

  config.vm.provision :shell, :path => "shell/final.sh", :args => config_json["vm"]["ip"]

end
