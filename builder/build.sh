#!/bin/bash

# Quit out if any command errors.
set -e

# Include local config file.
DIR="`pwd`"
if [[ $DIR != *"builder"* ]]
then
  DIR="$DIR/builder"
fi

# Development station
DEV_ROOT="$HOME/Sites"                  # root directory where drupal projects are stored
DEV_DB_USER="root"                # user account drupal will use to connect to db
DEV_HOST="127.0.0.1:3306"              # URL to the local host root, domain will be a subdir
DEV_DB_URL="mysql://${DEV_DB_USER}@${DEV_HOST}/"    # used to create the database and grant privileges

# Drush Configuration
DRUSH_ALIAS_DIR=""

# User ID 1 Configuration
USER="admin"
PASS="admin"
MAIL="admin@example.com"

# Extra
INSTALL_ROOT="$DEV_ROOT"                  # setup drupal in current working dir

# Variables set through user input
SITE_ID=""                              # unique identifier used for the domain
SITE_PATH=""
SITE_PROFILE="minimal"

# Include the local config file to override any existing settings.
if [ -f "$DIR/config.sh" ]; then
  source "$DIR/config.sh"
fi

# Contribe modules to download and install
MODULES_CONTRIB=(
  admin_menu admin_views bean ckeditor coffee ctools date devel entity entitycache
  entityreference features file_entity fpa globalredirect google_analytics honeypot
  libraries link mailsystem maillog mandrill masquerade master media metatag
  module_filter navbar navbar_region pathauto publication_date redirect reroute_email
  role_delegation role_export seckit simple_pass_reset site_policy strongarm
  styleguide token views views_bulk_operations warden xmlsitemap
)

MODULES_THEME=(
  bootstrap
)

#MODULES_I18N=(
#  translation translation_helpers
#  i18n i18n_block i18n_field i18n_node i18n_menu i18n_path i18n_redirect
#  i18n_select i18n_string i18n_sync i18n_translation i18n_variable l10n_update
#)

# Drupal make, gathers user input, configures and installs Drupal
make() {
  setSitePath $1

  echo -n "This will install a new Drupal site in the following directory: $SITE_PATH. Do you want to continue? (y/n): "
  read CONTINUE_INSTALL

  if [ "$CONTINUE_INSTALL" != "y" ]; then
    doing "Drupal site install cancelled!";
    exit 1
  fi

  doing "Making Drupal site..."

  # Check to see if the install directory already exists
  if [ -d $SITE_PATH ]; then
    doing "The directory '$SITE_PATH' already exists."

    echo -n "Would still like to create a new site at this location? (y/n): "
    read CONTINUE_SITE_INSTALL

    FORCE_SITE_INSTALL=false
    if [ "$CONTINUE_SITE_INSTALL" == "y" ]; then
      FORCE_SITE_INSTALL=true
    fi

    if [ "$FORCE_SITE_INSTALL" == false ]; then
      doing "Drupal site install cancelled!
You could try running './build.sh -i $SITE_ID' to run the site installation.";
      exit 1
    fi
  fi

  if [ "$FORCE_SITE_INSTALL" == true ]; then
    if [ -d "$SITE_PATH/docroot" ]; then
      mv "$SITE_PATH/docroot" "$SITE_PATH/docroot.old"
    fi
  else
    mkdir -p $SITE_PATH
  fi

  siteInstall
}

# Set the site paths
setSitePath() {
  if [ "$1" ]; then
    SITE_ID=$1
  else
    echo -n "Enter the site short name: "
    read SITE_ID
  fi

  # @todo check for SITE_ID ending in .dev and error/ strip it off
  SITE_PATH="${INSTALL_ROOT}/${SITE_ID}.dev"
  SITE_DOCROOT="$SITE_PATH/docroot"
  DRUSH_ALIAS_DIR="$SITE_DOCROOT/sites/all/drush"
}

# Create the Drupal site with info supplied from the make function
siteInstall() {
  doing "Setting up the install at ${SITE_PATH}"

  cd $SITE_PATH

  doing "Downloading Drupal..."
  drush dl drupal-7 --drupal-project-rename=docroot -y

  doing "Installing Drupal..."
  cd "$SITE_DOCROOT"

  # Create drush alias file
  createDrushAliases

  # Create the settings file.
  createSettingsFiles

  doing "Drupal base is ready for VDD provisioning.... add the site '${SITE_ID}' to the config file with the following and run 'vagrant provision':

  \"${SITE_ID}\": {
    \"account_name\": \"root\",
    \"account_pass\": \"root\",
    \"account_mail\": \"box@example.com\",
    \"site_name\": \"${SITE_ID}\",
    \"site_mail\": \"box@example.com\",
    \"vhost\": {
      \"document_root\" : \"${SITE_ID}.dev/docroot\",
      \"url\": \"${SITE_ID}.dev\",
      \"alias\": [\"www.${SITE_ID}.dev\"]
    }
  }

"

  echo -n "Press enter to continue site installation."
  read VDD_PROVISIONED

  installDrupal $1
}

installDrupal() {
  if [ "$SITE_DOCROOT" == "" ]; then
    setSitePath $1
  fi

  # Check to see if the install directory already exists
  if [ ! -d "$SITE_PATH" ]; then
    echo -e "Unable to install Drupal site as '$SITE_PATH' doesn't exist."
    exit 1
  fi

  cd "$SITE_DOCROOT"

  drush @vdd si -y ${SITE_PROFILE} --account-name=${USER} --site-name=${SITE_ID} --account-pass=${PASS} --account-mail=${MAIL} --site-mail=${MAIL} --sites-subdir=default

  # Download & enable desired modules
  downloadModules ${MODULES_CONTRIB[@]}

  # Download the themes to the theme directory
  for theme in ${MODULES_THEME[@]}; do
    drush @vdd dl -y --destination=sites/all/themes $theme
  done

  drush @vdd en -y master
  drush @vdd master-ensure-modules -y
  drush @vdd vset admin_theme seven

  doing "Finished the installation!

Read '/sites/all/modules/contrib/navbar/README.md' to install the javascript libraries for navbar.
"
  drush @vdd uli
}

# Enable modules
downloadModules() {
  for arg in $*; do
    for module in "${arg[@]}"; do
        drush @vdd dl -y $module
    done
  done
}

# Create an alias file for the current drupal build
createDrushAliases() {
  mkdir -p $DRUSH_ALIAS_DIR
  cp $DIR/includes/drush/drushrc.php ${DRUSH_ALIAS_DIR}/drushrc.php

  cp $DIR/includes/drush/aliases.drushrc.php ${DRUSH_ALIAS_DIR}/sites.aliases.drushrc.php
  searchReplace ${DRUSH_ALIAS_DIR}/sites.aliases.drushrc.php
}

# Creates the settings files.
createSettingsFiles() {
  CONF_DIR=$SITE_DOCROOT/sites/all/conf
  mkdir $CONF_DIR

  files=($DIR/includes/conf/*)
  for filepath in ${files[*]}
  do
    #dir=`dirname $filepath`
    file=`basename $filepath`
    cp $filepath $CONF_DIR/$file
    searchReplace $CONF_DIR/$file
  done

  cp $DIR/includes/settings.php $SITE_DOCROOT/sites/default/settings.php
  searchReplace $SITE_DOCROOT/sites/default/settings.php
}

# Streamline echoing status
doing() {
  echo -e "\n$1"
}

# Search replace a file to set the SITE_ID
searchReplace() {
  sed -i '' "s/SITE_ID/${SITE_ID}/g" $1
}

# Help info
usage() {
  cat << EOF
  Usage: ./build.sh [options]
         ./build.sh -m [site_name]
         ./build.sh -i [site_name]

  Drupal build script. Creates a new directory with the domain name within the
  specified path.

  Options:
EOF
  cat << EOF | column -s\& -t

    -h | help & show this output
    -m | build new site
    -i | install a Drupal site

EOF
}

# Check command flags invoked and store possible argumets
while getopts ":msih" opt; do
  case $opt in
    m) #build a site
      make $2
      ;;
    s) #create settings a drupal site
      setSitePath $2
      createSettingsFiles
      ;;
    i) #install a drupal site
      installDrupal $2
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done
