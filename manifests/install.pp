class gerrit::install(
  $rpm_key_source = 'puppet:///modules/gerrit/rpm-gerritforge.key',
  $deb_key_source = 'puppet:///modules/gerrit/deb-gerritforge.key'
) {

  if $gerrit::manage_repo {
    case $::osfamily {
      'redhat': {
        $gpgkey = '/etc/pki/rpm-gpg/RPM-GPG-KEY-GerritForge'

        file { $gpgkey:
          ensure => 'present',
          source => $rpm_key_source,
        }

        yumrepo { 'gerritforge':
          descr      => 'GerritForge repository for Gerrit Code Review',
          mirrorlist => 'http://mirrorlist.gerritforge.com/yum',
          enabled    => '1',
          gpgcheck   => '1',
          gpgkey     => "file://${gpgkey}",
          require    => File[$gpgkey],
          before     => Package['gerrit'],
        }

        $package_version = "${gerrit::version}-1"
      }
      'debian': {
        include apt

        $gpgkey = '/etc/apt/gerritforge.key'

        file { $gpgkey:
          ensure => 'present',
          source => $deb_key_source,
        }

        apt::source { 'gerritforge':
          location   => 'mirror://mirrorlist.gerritforge.com/deb',
          release    => 'gerrit',
          repos      => 'main',
          key        => {
            id     => 'F0E24DA66FFAA737081E5A7E1FFFAA5E1871F775',
            source => $gpgkey
          },
          require    => File[$gpgkey],
          before     => Package['gerrit'],
        }

        $package_version = $gerrit::version
      }
      default: {
        fail("Management of the Gerrit package repository is only available for RedHat and Debian families.")
      }
    }
  }

  if $gerrit::manage_package {
    # This isn't ideal... but the post-install hook uses sudo and puppet's execution doesn't provide a tty
    # When fixed in the upstream Gerrit packaging script this should be removed
    augeas { 'disable_sudoers_requiretty':
      context => '/files/etc/sudoers',
      changes => 'rm /Defaults[requiretty]'
    }

    package { 'gerrit':
      name   => $gerrit::package_name,
      ensure => $package_version,
    }
  }

}