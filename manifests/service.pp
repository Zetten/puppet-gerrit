class gerrit::service {

  if $gerrit::manage_service {
    service { 'gerrit':
      name    => $gerrit::service_name,
      ensure  => $gerrit::service_ensure,
      enable  => $gerrit::service_enable,
      require => Package['gerrit'],
    }

    $manual_service_script = "${gerrit::gerrit_home}/bin/gerrit.sh"
    $gerrit_reinit = "${manual_service_script} stop ; \
   java -jar ${gerrit::gerrit_home}/bin/gerrit.war init -d ${gerrit::gerrit_home} --batch"

    exec { 'gerrit_reinit':
      refreshonly => true,
      command     => $gerrit_reinit,
      user        => $gerrit::user,
      group       => $gerrit::group,
      notify      => Service['gerrit'],
      require     => Package['gerrit'],
    }
  }

}
