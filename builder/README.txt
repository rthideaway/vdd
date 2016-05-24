To install a new Drupal site run the following command from the vdd root:

./builder/build.sh -m [SHORT_NAME]

e.g. ./builder/build.sh -m deeson

** NOTE: the shortname is without the '.dev' on the end.

This will create a new directory for the drupal installation in:

  /Users/[USERNAME]/Sites/deeson.dev

The script will:

 1) Download the latest version of Drupal 7 to the docroot directory
 2) Create a base drush aliases files
 3) Create all the deeson default *.settings.inc files in conf directory
 4) Create the deeson default settings.php file
 5) Generate the config needed to add to the VDD config.json file and display it to the user
 6) Install Drupal using the standard install profile
 7) Download all the default modules that have been agreed should be present
 8) Download the bootstrap theme to the themes directory
 9) Enable the master module
10) Run master-ensure-modules to install all the default modules
11) Generate a one time login for you to access the site

BOOM your site is now all set up and configured ready to start building.

** NOTES **
Due to the additional Javascript files that are needed for the navbar module,
these currently need to be manually downloaded into the relevant libraries directory.
