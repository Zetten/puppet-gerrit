class gerrit::config {

  case $gerrit::manage_service {
    true: { $notify = Exec['gerrit_reinit'] }
    default: { $notify = [] }
  }

  $config_files = ["${gerrit::gerrit_home}/etc/gerrit.config", "${gerrit::gerrit_home}/etc/secure.config"]

  file { "${gerrit::gerrit_home}/etc":
    ensure  => directory,
    owner   => $gerrit::user,
    group   => $gerrit::group,
    require => File[$gerrit::gerrit_home],
    mode    => '0755'
  }

  file { "${gerrit::gerrit_home}/etc/gerrit.config":
    ensure  => present,
    owner   => $gerrit::user,
    group   => $gerrit::group,
    require => File["${gerrit::gerrit_home}/etc"],
    mode    => '0644',
    audit   => [content],
    notify  => $notify,
  }

  file { "${gerrit::gerrit_home}/etc/secure.config":
    ensure  => present,
    owner   => $gerrit::user,
    group   => $gerrit::group,
    require => File["${gerrit::gerrit_home}/etc"],
    mode    => '0600',
    audit   => [content],
    notify  => $notify,
  }

  create_ini_settings($gerrit::gerrit_config, {
    path   => "${gerrit::gerrit_home}/etc/gerrit.config",
    notify => File["${gerrit::gerrit_home}/etc/gerrit.config"]
  })

  create_ini_settings($gerrit::secure_config, {
    path   => "${gerrit::gerrit_home}/etc/secure.config",
    notify => File["${gerrit::gerrit_home}/etc/secure.config"]
  })

  each($gerrit::extra_configs) |$configname, $settings| {
    $config_file = "${gerrit::gerrit_home}/etc/${configname}"

    file { $config_file:
      ensure  => present,
      owner   => $gerrit::user,
      group   => $gerrit::group,
      require => File["${gerrit::gerrit_home}/etc"],
      mode    => '0644',
      audit   => [content],
      notify  => $notify,
    }

    create_ini_settings($settings, {
      path   => $config_file,
      notify => File[$config_file],
    })

    $config_files = $config_files + $config_file
  }

  if $gerrit::manage_db {
    contain gerrit::config::db
  }

}
