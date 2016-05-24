<?php

/**
 * @file
 * Aliases for different environments.
 */

$aliases['vdd'] = array(
  'env' => 'vdd',
  'uri' => 'SITE_ID.dev',
  'root' => '/var/www/vhosts/SITE_ID.dev/docroot',
);

if (!file_exists('/var/www/vhosts/SITE_ID.dev/docroot')) {
  $aliases['vdd']['remote-host'] = 'dev.local';
  $aliases['vdd']['remote-user'] = 'vagrant';
}
