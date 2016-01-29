<?php

/**
 * @file
 * Settings for maillog module.
 */

$conf['mail_system'] = array(
  'default-system' => 'MaillogMailSystem',
  'maillog' => 'MaillogMailSystem',
);

$conf['maillog_send'] = SETTINGS_ENVIRONMENT === 'prod';
$conf['maillog_log']  = SETTINGS_ENVIRONMENT !== 'prod';
$conf['maillog_devel'] = SETTINGS_ENVIRONMENT === 'dev';
$conf['maillog_engine'] = 'DefaultMailSystem';