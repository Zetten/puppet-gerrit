# Class: gerrit
# ===========================
#
# Documentation in README.md
#
# Parameters
# ----------
#
# * `manage_user`
# True if this module should install and manage a Gerrit user and group.
#   Default: true
#
# * `manage_repo`
# True if this module should install the Gerrit package repositories
# provided by GerritForge. If you have your own repo, set this parameter
# to false and manage the repository manually.
# (See http://gitenterprise.me/2015/02/27/gerrit-2-10-rpm-and-debian-packages-available/)
#   Default: true
#
# * `manage_package`
# True if this module should install and manage a Gerrit package.
#   Default: true
#
# * `package_name`
# The name of the package to be installed.
#   Default: 'gerrit'
#
# * `version`
# The Gerrit version to be installed. This is used to set the `ensure`
# parameter to the package class to avoid unexpected package upgrades.
#   Default: '2.12.2'
#
# * `gerrit_home`
# The path to the Gerrit base directory. The default matches the path
# used by the gerrit-installer packages (e.g. the packages provided by
# GerritForge). If you are using a custom package (or installing Gerrit
# manually) you might have to change this.
#   Default: '/var/gerrit'
#
# * `user`
# The name of the Gerrit user. The user is not managed by this package,
# but some resources make use of it.
#   Default: 'gerrit'
#
# * `group`
# The primary group of the Gerrit user. The group is not managed by this
# package, but some resources make use of it.
#   Default: 'gerrit'
#
# * `gerrit_config`
# Hash describing ini variables to be set in the gerrit.config file.
# These are maintained by the puppetlabs-inifile module, which will
# leave the remainder of the file unmodified. If you need to remove a
# config variable, simply delete it from the gerrit.config file or add
# it to the hash with `ensure: absent` as described in the inifile
# documentation.
#   Default: {} (empty hash)
#
# * `secure_config`
# Hash describing ini variables to be set in the secure.config file. See
# the `gerrit_config` parameter for more details.
#   Default: {} (empty hash)
#
# * `extra_configs`
# Hash describing extra config files to be created, in the format
# `{ 'extrafile.config': { 'key': 'value'} }`. See the `gerrit_config`
# parameter for more details.
#   Default: {} (empty hash)
#
# * `manage_db`
# True if this module should manage the Gerrit database. The database
# parameters are retrieved directly from the `gerrit_config` hash.
# Currently it is only possible to add MySQL and PostgreSQL databases on
# localhost, and either option requires the installation of the
# puppetlabs-mysql or puppetlabs-postgresql module respectively.
#   Default: false
#
# * `manage_service`
# True if this module should manage the Gerrit service. This includes
# the actual service enable/disable/start/stop functionality, but also
# ensures that the Gerrit site initialisation is run after any config
# change. This _should_ be idempotent but verification in a test
# environment would be wise.
#   Default: true
#
# * `service_name`
# The name of the system service to be managed by this module.
#   Default: 'gerrit'
#
# * `service_enable`
# Tells Puppet whether the managed service should be enabled to start at
# boot.
#   Default: true
#
# * `service_ensure`
# Tells Puppet whether the managed service should be running. Valid
# options: 'running' or 'stopped'.
#   Default: 'running'
#
# Authors
# -------
#
# Peter van Zetten <peter.vanzetten@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Peter van Zetten, unless otherwise noted.
#
class gerrit(
  # Installation configuration
  $manage_user,
  $manage_repo,
  $manage_package,
  $package_name,
  $version,
  $gerrit_home,
  $user,
  $group,
  # Configuration file content
  $gerrit_config,
  $secure_config,
  $extra_configs,
  # Database configuration
  $manage_db,
  # Service configuration
  $manage_service,
  $service_name,
  $service_enable,
  $service_ensure,
) {

  validate_bool($manage_repo)
  validate_bool($manage_package)
  validate_string($package_name)
  validate_string($version)
  validate_absolute_path($gerrit_home)
  validate_string($user)
  validate_string($group)

  validate_hash($gerrit_config)
  validate_hash($secure_config)
  validate_hash($extra_configs)

  validate_bool($manage_db)

  validate_bool($manage_service)
  validate_string($service_name)
  validate_bool($service_enable)
  validate_string($service_ensure)

  contain ::gerrit::install
  contain ::gerrit::service
}
