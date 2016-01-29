<?php

/**
 * @file
 * The default settings.php.
 */

$base_domains = array(
  'SITE_ID.dev' => 'local',
  'dev.example.co.uk' => 'dev',
  'stage.example.co.uk' => 'test',
  'www.example.co.uk' => 'prod',
);

// pulsant/ acquia/ pantheon.
$platform = 'pulsant';
$instance = $_SERVER['HTTP_HOST'];
$env = $base_domains[$_SERVER['HTTP_HOST']];

if (file_exists('/var/www/settings/SITE_ID/settings.inc')) {
  $platform = 'vdd';
  require_once '/var/www/settings/SITE_ID/settings.inc';
}

if (!empty($env) && !empty($platform) && !empty($instance)) {
  define('SETTINGS_ENVIRONMENT', $env);
  define('SETTINGS_INSTANCE', $instance);
  define('SETTINGS_PLATFORM', $platform);

  foreach (glob('sites/all/conf/*.settings.inc') as $file) {
    require_once $file;
  }
}
