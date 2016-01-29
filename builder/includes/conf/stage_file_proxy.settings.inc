<?php

/**
 * @file
 * Stage file proxy.
 */

if (SETTINGS_ENVIRONMENT !== 'prod') {
  //$conf['stage_file_proxy_origin'] = 'https://www.example.co.uk';
  $conf['stage_file_proxy_origin_dir'] = 'sites/default/files';
  $conf['stage_file_proxy_hotlink'] = FALSE;
}