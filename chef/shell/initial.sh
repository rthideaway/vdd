#!/bin/bash

VAGRANT_DIR="/vagrant"

# Branding...
cat "$VAGRANT_DIR/chef/shell/vdd.txt"

# Upgrade Chef.
echo "Updating the OS. This may take a few minutes..."
apt-add-repository ppa:brightbox/ruby-ng -y
apt-get update
apt-get install ruby2.2 ruby2.2-dev -y
gem install chef --version 11.12.4 --no-rdoc --no-ri --conservative &> /dev/null
