<?php

//define('DEBUG', 1);

/**
 * External binaries
 */

define('TEX_PATH', '/usr/local/texlive/2020/bin/x86_64-linux/');
define('SVGO_PATH', '../node_modules/svgo/bin');

/**
 * Setting up directories
 * Relative to www/render.php
 */

// LaTeX document templates
define('TPL_DIR', '../tpl/');

// Render errors log
define('LOG_DIR', './tex_logs');

// Cache and temp dirs
define('TMP_DIR', 'tmp/');
define('CACHE_SUCCESS_DIR', '_cache/');
define('CACHE_FAIL_DIR', '_error/');

/**
 * Setting up rendering scale
 * Do not forget to clear the cache dir when changing this.
 */

define('OUTER_SCALE', 1.00375 * 1.25);

/**
 * PHP-FPM socket for delayed queue for postprocessing of cache files
 */
define('FASTCGI_SOCKET', '/var/run/php/php7.3-fpm.sock');
