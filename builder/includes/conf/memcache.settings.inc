<?php

/**
 * @file
 * Memcache settings.
 */

// VDD handles its memcache settings itself.
if (SETTINGS_PLATFORM !== 'vdd') {
  $conf['cache_backends'][] = './sites/all/modules/contrib/memcache/memcache.inc';
  $conf['cache_default_class'] = 'MemCacheDrupal';
  $conf['cache_class_form'] = 'DrupalDatabaseCache';
  $conf['cache_class_cache_form'] = 'DrupalDatabaseCache';
  $conf['lock_inc'] = 'sites/all/modules/contrib/memcache/memcache-lock.inc';
  $conf['memcache_stampede_protection'] = TRUE;
  $conf['memcache_servers'] = array('127.0.0.1:11211' => 'default');
  $conf['memcache_key_prefix'] = SETTINGS_INSTANCE;
}