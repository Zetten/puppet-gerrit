class gerrit::install::user {
  group { $gerrit::group:
    ensure => present,
  }

  user { $gerrit::user:
    ensure     => present,
    gid        => $gerrit::group,
    home       => $gerrit::gerrit_home,
    managehome => false,
    require    => Group[$gerrit::group],
    shell      => '/bin/bash',
    system     => true,
  }

  file { $gerrit::gerrit_home:
    ensure  => directory,
    owner   => $gerrit::user,
    group   => $gerrit::group,
    require => User[$gerrit::user],
  }
}