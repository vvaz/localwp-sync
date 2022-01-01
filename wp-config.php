<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'local' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', 'root' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '3c1e99vFn2e6PYq4uxcTmLoPE+jZ3I3qBckyNAEBcMZ4E/DMHetacYuDoqiGdPAY9XWIpb3kzG7eQryfyhLmkw==');
define('SECURE_AUTH_KEY',  'doAsFO8gru+cS1+pAk5779/i2x7vhsFZkkC6Vo2pmdhDk3j8M1p896FvWkSW+W5CmCaBV0PAsjS1nSx2AKM/ZQ==');
define('LOGGED_IN_KEY',    'l67XSnr6wygcj3cQZHyEbzS1Z5mh2/du/XDpkmXOxoniTTlDAkZJYo+Zfvp4EpTyQ6OVpQMXA0lwAxUFpW/uAQ==');
define('NONCE_KEY',        'o4Nqs/iRBKcUJsEZuTbbHsWs/n50QOLZPYawwO/imMVgJWSaWX8yZ+wPHIizmiaJxUk+geyhOgIv2KZDFy24JQ==');
define('AUTH_SALT',        'j0g5Q2WpQzgkrhj10ccnf4hTFk1B0WIxube8QQLcFF3Am7k/2PDKgjOG+RfY7K2GFzOMcXmhKwf+6K5hS+Zahg==');
define('SECURE_AUTH_SALT', 'Ychk6Da7d3DzxsLnXMPWdVpLyajqMqS4q5Ydey9CW+cu2ixjWfFUe/xPEO26UqlLT9HwmHZN4ALqM71W7f7wxA==');
define('LOGGED_IN_SALT',   'EagOgymDIlaC7ADxmIBxZcL6cndOWhflADlMlN8kDag3lh+rE0xRhrt9iJiMHgWD6t3dLao1FFvoFs2vmv/ZPg==');
define('NONCE_SALT',       'd1rImd4cuwIlglP0ycDU8rd5O+qzMUJoA2st1ZNVuDeRumWVR3nQvnANfL+RL9qoGaYWWWXfUJV4SNZmEnaytA==');

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


# some development options:
// Enable WP_DEBUG mode
define( 'WP_DEBUG', true );
// Enable Debug logging to the /wp-content/debug.log file
define( 'WP_DEBUG_LOG', true );
# Enable development mode for jetpack
add_filter( 'jetpack_development_mode', '__return_true' );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
