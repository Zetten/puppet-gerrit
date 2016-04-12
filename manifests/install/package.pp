class gerrit::install::package {

  case $::osfamily {
    'redhat': {
      if $gerrit::version !~ /^(present|latest|absent)$/ {
        $package_version = "${gerrit::version}-1"
      } else {
        $package_version = $gerrit::version
      }
    }
    'debian': {
      $package_version = $gerrit::version
    }
    default: {
      fail("Management of the Gerrit package is only available for RedHat and Debian families.")
    }
  }

  # This isn't ideal... but the post-install hook uses sudo and puppet's execution doesn't provide a tty
  # When fixed in the upstream Gerrit packaging script this should be removed
  augeas { 'disable_sudoers_requiretty':
    changes => 'rm /files/etc/sudoers/Defaults[requiretty]',
    before  => Package['gerrit'],
  }

  package { 'gerrit':
    name    => $gerrit::package_name,
    ensure  => $package_version,
    require => Class['::gerrit::config'],
  }
}

