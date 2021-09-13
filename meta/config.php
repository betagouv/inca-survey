<?php if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

$IS_PRODUCTION = getenv('PHP_ENV') === "production";
$DATABASE_URL = implode(
  array(
    'mysql:',
    'host=' . getenv('LIMESURVEY_DATABASE_HOST') . ';',
    'port=' . getenv('LIMESURVEY_DATABASE_PORT') . ';',
    'dbname=' . getenv('LIMESURVEY_DATABASE_NAME') . ';',
  )
);

return array(
  'components' => array(
    // Site
    'sitename'                => 'Lab Agora',
    // https://manual.limesurvey.org/Optional_settings#General_settings
    // 'siteadminemail'          => '',
    // 'siteadminbounce'         => '',
    // 'siteadminname'           => '',

    // Database
    'db' => array(
      'charset'                 => 'utf8mb4',
      'connectionString'        => $DATABASE_URL,
      'emulatePrepare'          => true,
      'password'                => getenv('LIMESURVEY_DATABASE_PASSWORD'),
      'tablePrefix'             => 'lime_',
      'username'                => getenv('LIMESURVEY_DATABASE_USERNAME'),
    ),

    // Request
    'request' => array(
      // 'baseUrl'               => getenv('LIMESURVEY_BASE_URL'),
    ),

    // Session
    'session' => array(
      'cookieParams' => array(
        'httponly'            => $IS_PRODUCTION,
        'secure'              => $IS_PRODUCTION,
      ),
    ),

    // URL
    'urlManager' => array(
      'showScriptName'        => false,
      'rules'                 => array(),
      'urlFormat'             => 'path',
    ),
  ),

  'config' => array(
    // Bootstrap
    'defaultpass'             => getenv('LIMESURVEY_ADMIN_PASSWORD'),
    'defaulttheme'            => 'vanilla',
    'defaultuser'             => getenv('LIMESURVEY_ADMIN_USERNAME'),

    // Localization
    'defaultlang'             => 'fr',
    'restrictToLanguages'     => 'fr',

    // Extra
    'debug'                   => $IS_PRODUCTION ? 0 : 1,
    'debugsql'                => 0,
    'ssl_disable_alert'       => !$IS_PRODUCTION,
  ),
);
