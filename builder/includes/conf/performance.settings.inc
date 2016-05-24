<?php

/**
 * @file
 * Performance settings.
 */

if (SETTINGS_ENVIRONMENT !== 'dev') {
  $conf['css_gzip_compression'] = TRUE;
  $conf['js_gzip_compression'] = TRUE;
  $conf['page_cache_invoke_hooks'] = FALSE;
  $conf['cache'] = 1;
  $conf['cache_lifetime'] = 0;
  $conf['page_cache_maximum_age'] = 21600;
}