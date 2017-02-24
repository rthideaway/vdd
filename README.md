Vagrant Drupal Development
--------------------------

This is the Deeson fork of Vagrant Drupal Development (VDD) is fully configured and ready to use
development environment built with VirtualBox, Vagrant, Linux and Chef Solo
provisioner.

We use this on MacOSX - if you use other OS then your mileage may vary.

Getting Started
---------------

### VDD Installation (from scratch - update instructions below)

You should have git installed, type git and complete the xcode command line tools instructions if it pops up.

Once xcode is installed, run sudo git as the local admin user to agree to the terms and conditions

You will need a github account with the SSH key installed.

1. Goto https://github.com/join to create an account
2. Create a local SSH key and install it into your github account by following
   [these instructions](https://help.github.com/articles/generating-ssh-keys/)

You will also need to have sudo access for your local user. Get a senior dev to add this for you.

[Install Vagrant](http://www.vagrantup.com/downloads.html)

[Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)

These instructions include setting up a raw D7 site with shortname drupal7.

1. `cd ~/Applications`
2. `git clone git@github.com:teamdeeson/vdd.git`
3. `cd vdd`
4. `git checkout develop/xenial`
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
          User ubuntu
          UserKnownHostsFile /dev/null
          StrictHostKeyChecking no
          PasswordAuthentication no
          IdentityFile [IdentityFile]
          IdentitiesOnly yes
          RequestTTY Yes
          LogLevel QUIET


## Xenial update instructions

If you were previously tracking develop and would like to switch to the new Xenial release follow the instructions below.

The Xenial branch is slimmed down from the original for developer ease (no Varnish for example) and runs Ubuntu Xenial OS and PHP 7.0

1. Make sure you are running the latest versions of [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.virtualbox.org/wiki/Downloads)
2. There is a chance you will lose the files on your persistent storage during this process. If you can backup the file at ~/Applications/vdd/persistant-storage.vdi then do this. Otherwise, you can just take some db backups of your active projects so you can restore them after if this happens.
3. cd ~/Applications/vdd
4. vagrant destroy
5. Switch to the new branch:  git fetch && git checkout xenial/develop
6. Edit your config.json file - compare with the config.json.example file, there is a new line required ("domain\_suffix": "dev") also you can remove ("persist\_db": true). You could also take this opportunity to remove unnecessary lines from the individual site configurations in the file as well (compare with the new example file)
vagrant up - this will build the new VDD box by downloading a Xenial OS image from ubuntu and installing the more mimimal set of packages.
7. Once complete you will need to go into the box and change the owner of the mysql files stored in the persistent storage as the UID of the mysql user will have changed:
vagrant ssh
8. cd /mnt/persistent/mysql
9. sudo chown -R mysql.mysql .
10. sudo service mysql restart
11. On your Mac, you'll need to make a change your to ssh config file because the user on the Xenial box has changed from vagrant to ubuntu
    edit ~/.ssh/config
12. Find the section which starts Host dev.local
13. Change User vagrant to User ubuntu  (if this is missing then add it)

#### Drush aliases

Some of your sites may have hard coded coded the vdd user as `vagrant`. The best thing to do is to remove these lines from the projects drush aliases file.  i.e. in the sites/all/drush/sites.aliases.drushrc.php file remove any lines that look like this:

    $aliases['vdd']['remote-user'] = 'vagrant';

### Known issues

If you get an error like this:

   The following SSH command responded with a non-zero exit status.
   Vagrant assumes that this means the command failed!
   mount -o 'vers=3,udp' 192.168.44.1:'/Users/[User]/Applications/vdd/data' /var/www

The peristant storage plugin has gone wonky. You can repair it by executing the following commands:

1. Upgrade to the latest version of Vagrant
2. Repair Vagrant with
```vagrant plugin repair```
3. Expunge and reinstall Vagrant plugins with
```vagrant plugin expunge —reinstall```
4. Reinstall persistent storage plugin which went missing after step 3 with
```vagrant plugin install vagrant-persistent-storage```
