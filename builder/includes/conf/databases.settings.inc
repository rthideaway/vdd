<?php

/**
 * @file
 * Database configuration per instance.
 */

if (!isset($databases)) {
  $databases = array();
}

if (in_array(SETTINGS_INSTANCE, array('www.example.co.uk'))) {
  $databases['default']['default'] = array(
    'driver' => 'mysql',
    'database' => '',
    'username' => '',
    'password' => '',
    'host' => '127.0.0.1',
    'port' => 3306,
    'prefix' => '',
    'collation' => 'utf8_general_ci',
  );
}
elseif (in_array(SETTINGS_INSTANCE, array('stage.example.co.uk'))) {
  $databases['default']['default'] = array(
    'driver' => 'mysql',
    'database' => '',
    'username' => '',
    'password' => '',
    'host' => '127.0.0.1',
    'port' => 3306,
    'prefix' => '',
    'collation' => 'utf8_general_ci',
  );
}
elseif (SETTINGS_INSTANCE === 'dev.example.co.uk') {
  $databases['default']['default'] = array(
    'driver' => 'mysql',
    'database' => '',
    'username' => '',
    'password' => '',
    'host' => '127.0.0.1',
    'port' => 3306,
    'prefix' => '',
    'collation' => 'utf8_general_ci',
  );
}