class gerrit::config::db {
  # Grab the database config directly from the gerrit.conf/secure.config contents
  $db_config = merge($gerrit::gerrit_config['database'], $gerrit::secure_config['database'])
  validate_hash($db_config)

  $type = $db_config['type']
  $hostname = $db_config['hostname']
  $database = $db_config['database']
  $username = $db_config['username']
  $password = $db_config['password']

  validate_string($type)
  validate_re($hostname, '^localhost$', 'Only databases with $hostname \'localhost\' may be managed by this module.')
  validate_string($database)
  validate_string($username)
  validate_string($password)

  case $gerrit::manage_service {
    true: { $before = Exec['gerrit_reinit'] }
    default: { $before = [] }
  }

  case upcase($type) {
    'MYSQL': {
      require ::mysql::server

      mysql::db { 'gerritdb':
        host     => $hostname,
        dbname   => $database,
        user     => $username,
        password => $password,
        grant    => ['ALL'],
        before   => $before,
      }
    }
    'POSTGRESQL': {
      require ::postgresql::server

      postgresql::server::db { 'gerritdb':
        dbname   => $database,
        user     => $username,
        password => postgresql_password($username, $password),
        grant    => 'ALL',
        before   => $before,
      }
    }
    default: {
      fail("Only MySQL and PostgreSQL databases may be managed by this module.")
    }
  }

}