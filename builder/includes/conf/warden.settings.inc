<?php

/**
 * @file
 * Warden settings.
 */

$conf['warden_server_host_path'] = 'https://warden.titan-dev.deeson.net';
$conf['warden_allow_requests'] = TRUE;
$conf['warden_public_allow_ips'] = '127.0.0.1,2001:4800:7811:513:59b9:beb2:ff04:b7a1,166.78.17.97';
$conf['warden_http_username'] = 'tdev';
$conf['warden_http_password'] = 'QJCY6zbn';
//$conf['warden_token']= '';
$conf['warden_context_options'] = array(
  'ssl' => array(
    'verify_peer'   => TRUE,
    'cafile'        => 'sites/all/conf/warden.crt',
  ),
);