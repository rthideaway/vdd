<?php

/**
 * @file
 * Master module settings.
 */

$conf['master_current_scope'] = SETTINGS_ENVIRONMENT;

$conf['master_version'] = 2;

$conf['master_modules']['local'] = array(
  'context_ui',
  'field_ui',
  'views_ui',
  'hacked',
  'dblog',
  'devel',
  'update',
  'stage_file_proxy',
  'coder',
  'coder_review',
);

$conf['master_modules']['dev'] = array(
  'context_ui',
  'field_ui',
  'views_ui',
  'dblog',
  'devel',
  'update',
  'stage_file_proxy',
);

$conf['master_modules']['test'] = array(
  'syslog',
  'purge',
  'expire',
  'stage_file_proxy',
);

$conf['master_modules']['prod'] = array(
  'syslog',
  'purge',
  'expire',
);

$conf['master_modules']['base'] = array (
  'admin_views',
  'bean',
  'ckeditor',
  'coffee',
  'ctools',
  'date',
  'devel',
  'entity',
  'entitycache',
  'entityreference',
  'features',
  'fpa',
  'globalredirect',
  'google_analytics',
  'honeypot',
  'libraries',
  'link',
  'mailsystem',
  'mandrill',
  'maillog',
  'masquerade',
  'master',
  'media',
  'metatag',
  'module_filter',
  'navbar',
  'navbar_region',
  'pathauto',
  'publication_date',
  'redirect',
  'reroute_email',
  'role_delegation',
  'role_export',
  'seckit',
  'simple_pass_reset',
  'site_policy',
  'strongarm',
  'styleguide',
  'token',
  'views',
  'warden',
  'xmlsitemap',

  // Custom modules.
);
