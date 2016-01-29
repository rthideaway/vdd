<?php

/**
 * @file
 * Core Drupal settings.
 */

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strtolower($_SERVER['HTTP_X_FORWARDED_PROTO']) === 'https') {
  $_SERVER['HTTPS'] = 'on';
}

$conf['404_fast_paths_exclude'] = '/\/(?:styles)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
$conf['404_fast_html'] = '<html xmlns="http://www.w3.org/1999/xhtml"><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>';

$update_free_access = FALSE;
$drupal_hash_salt = '';

$conf['date_format_medium'] = 'dS F Y';
$conf['site_default_country'] = 'GB';
$conf['date_first_day'] = '1';
$conf['date_default_timezone'] = 'Europe/London';
$conf['configurable_timezones'] = '0';

$conf['reverse_proxy_header'] = 'HTTP_X_FORWARDED_FOR';
$conf['omit_vary_cookie'] = TRUE;

// Tell Drupal it's behind a proxy.
$conf['reverse_proxy'] = TRUE;

// Tell Drupal what addresses the proxy server(s) use.
$conf['reverse_proxy_addresses'] = array('127.0.0.1');

$conf['image_allow_insecure_derivatives'] = TRUE;

$conf['site_name'] = 'SITE_ID';
if (SETTINGS_ENVIRONMENT !== 'prod') {
  $conf['site_name'] = '[' . SETTINGS_ENVIRONMENT . '] ' . $conf['site_name'];
}

// Cron check will fail if cron has not run for 2 hrs.
$conf['drushcroncheck_time_to_check'] = 7200;

// Never run poormanscron.
$conf['cron_safe_threshold'] = '0';

// Token tweaks.
$conf['token_tree_recursion_limit'] = '4';

$base_url = 'https://' . SETTINGS_INSTANCE;
