<?php

/**
 * @file
 * Redirects.
 */

if (!drupal_is_cli()) {
  // Don't do redirects on instances with self signed SSL certificates.
  $no_redirects_instances = array(
    'SITE_ID.dev',
    'dev.example.co.uk',
    'stage.example.co.uk',
  );

  // Redirect HTTP to HTTPS.
  if (!in_array(SETTINGS_INSTANCE, $no_redirects_instances)) {
    if (strtolower($_SERVER['HTTPS']) !== 'on' || $_SERVER['HTTP_HOST'] !== SETTINGS_INSTANCE) {
      header('HTTP/1.0 301 Moved Permanently');
      header('Location: https://' . SETTINGS_INSTANCE . $_SERVER['REQUEST_URI']);
      exit();
    }
  }
}
