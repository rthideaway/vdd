Vagrant Drupal Development
--------------------------

This is a fork of Vagrant Drupal Development (VDD) is fully configured and ready to use
development environment built with VirtualBox, Vagrant, Linux and Chef Solo
provisioner.

The main goal of the project is to provide easy to use, fully functional, highly
customizable and extendable Linux based environment for Drupal development.

Full VDD documentation can be found on drupal.org:
https://drupal.org/node/2008758


Getting Started
---------------

### VDD Installation

You should have git installed, type git and complete the xcode command line tools instructions if it pops up.

Once xcode is installed, run sudo git as the local admin user to agree to the terms and conditions

You will need a github account with the SSH key installed.

1. Goto https://github.com/join to create an account
2. Create a local SSH key and install it into your github account by following
   [these instructions](https://help.github.com/articles/generating-ssh-keys/)

You will also need to have sudo access for your local user. Get a senior dev to add this for you.

[Install Vagrant](http://www.vagrantup.com/downloads.html)

[Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)

### VDD initial configuration

These instructions include setting up a raw D7 site with shortname drupal7.

1. `cd ~/Applications`
2. `git clone git@github.com:teamdeeson/vdd.git`
3. `cd vdd`
4. `git checkout develop`
5. `cp config.example.json config.json`
6. edit config.json - you should also add your first site configuration now as well. We will include a raw Drupal 7 instance as an example. This project shortname is drupal7. Replace placeholders in the file from [shortname] with drupal7
7. Setup your DNS so that requests to all domains ending in .dev are sent to the vagrant box by running these commands. After doing this it takes a little while for everything to start resolving. Try flushing DNS cache or just restart your Mac.


        su - localadmin
        sudo mkdir -p /etc/resolver
        sudo tee /etc/resolver/dev >/dev/null <<EOF
        nameserver 192.168.44.44
        EOF
        exit


8. Check that you have a Sites directory in your home folder (~/Sites)
9. `vagrant plugin install vagrant-persistent-storage` This installs a plugin which allows the databases to be stored in an external file
10. Go to [synced folder instructions](https://docs.vagrantup.com/v2/synced-folders/nfs.html) and skip to the section labelled “Root Privilege Requirement”. Add the section required for OSX to your sudoers file.
11. `vagrant up` this step takes a while to go through as it is downloading the OS image & all needed software packages so go do something else
12. `vagrant provision` this step also takes a while as all the packages need to be downloaded and configured.
13. When done, go to [http://192.168.44.44](http://192.168.44.44) to confirm it is working. You should get an HTML page back.
14. Configure the ssh config to connect to your VDD box. To do this, run the following command within the vdd directory `cd ~/Applications/vdd; vagrant ssh-config`. Make a note of the IdentityFile path.
    Edit the file `~/.ssh/config` and add the following to the end. Later, this will allow you to automatically ssh into the virtual box via ssh dev.local
    Replace [IdentityFile] with the path from the vagrant ssh config output.


        Host dev.local
          HostName 192.168.44.44
          User vagrant
          UserKnownHostsFile /dev/null
          StrictHostKeyChecking no
          PasswordAuthentication no
          IdentityFile [IdentityFile]
          IdentitiesOnly yes
          RequestTTY Yes
          LogLevel QUIET
          SendEnv PHP_IDE_CONFIG


