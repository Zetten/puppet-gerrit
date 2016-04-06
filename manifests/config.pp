class gerrit::config {

  $config_files = ["${gerrit::gerrit_home}/etc/gerrit.config", "${gerrit::gerrit_home}/etc/secure.config"]

  create_ini_settings($gerrit::gerrit_config, { path => "${gerrit::gerrit_home}/etc/gerrit.config" })
  create_ini_settings($gerrit::secure_config, { path => "${gerrit::gerrit_home}/etc/secure.config" })

  each($gerrit::extra_configs) |$configname, $settings| {
    $config_file = "${gerrit::gerrit_home}/etc/${configname}"
    create_ini_settings($gerrit::settings, { path => $config_file })
    $config_files = $config_files + $config_file
  }

  case $gerrit::manage_service {
    true: { $notify = Exec['gerrit_reinit'] }
    default: { $notify = [] }
  }

  file { $config_files:
    audit  => [content],
    notify => $notify
  }

  if $gerrit::manage_db {
    contain gerrit::config::db
  }

}