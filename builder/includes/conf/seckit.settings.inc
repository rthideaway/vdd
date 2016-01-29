<?php

/**
 * @file
 * Settings for seckit.
 */

$origin_white_list = array(
);

$conf['seckit_csrf'] = array(
  'origin_whitelist' => (empty($origin_white_list[SETTINGS_INSTANCE]) ? '' : $origin_white_list[SETTINGS_INSTANCE]),
);

$https_only = array(
  'stage.example.co.uk',
  'www.example.co.uk',
);

$conf['seckit_ssl'] = array(
  'hsts' => in_array(SETTINGS_INSTANCE, $https_only),
  'hsts_max_age' => '604000',
  'hsts_subdomains' => FALSE,
);
