<?php

/**
 * @file
 * File settings.
 */

$conf['file_public_path'] = 'files';

if (SETTINGS_PLATFORM === 'vdd') {
  $conf['file_temporary_path'] = '/tmp';
}
else {
  $conf['file_temporary_path'] = '../tmp';
}