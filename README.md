# gerrit

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with gerrit](#setup)
    * [What gerrit affects](#what-gerrit-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with gerrit](#beginning-with-gerrit)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The gerrit module installs, configures, and manages the Gerrit service.

This module installs Gerrit as an OS package from the [GerritForge repositories](http://gitenterprise.me/2015/02/27/gerrit-2-10-rpm-and-debian-packages-available/) and manages its configuration files and (optionally) the backing database.

## Setup

### What gerrit affects

This module by default will simply install the Gerrit package and start the service. If configuration parameters are specified, the variables will be set in the Gerrit configuration files as-is; the configuration files as a whole are not managed by this module.

If a `database` section is set in the `gerrit_config` parameter, this module can optionally manage the database (if configured on localhost) with `manage_db` set to True. This trivially creates the appropriate database resource via other modules, but does not otherwise manage the database server.

### Setup Requirements

The Puppet modules required to manage the Gerrit database are not specified as hard dependencies of this module. Therefore if you wish to set `manage_db` to true you should ensure that `puppetlabs-mysql` or `puppetlabs-postgresql` are available.

## Usage

To install Gerrit with the default options simply include the `::gerrit` class. All configuration is handled as class parameters to `gerrit` and is possible to be set via hiera data.

**Warning**: The defaults include the unsafe `auth` mode `DEVELOPMENT_BECOME_ANY_ACCOUNT`. A production instance of Gerrit *must* configure the `auth` section in `gerrit_config`.

## Reference

### Classes

#### Public classes

* `gerrit`: Installs and configures Gerrit.

#### Private classes

* `gerrit::install`: Installs the Gerrit repository and package.
* `gerrit::config`: Configures Gerrit's config files and database.
* `gerrit::config::db`: Configures a backing database for Gerrit.
* `gerrit::service`: Manages the Gerrit service, including running the site initialisation.

### Parameters

#### gerrit

##### `manage_repo`
True if this module should install the Gerrit package repositories
provided by GerritForge. If you have your own repo, set this parameter
to false and manage the repository manually.

Default: true

##### `manage_package`
True if this module should install and manage a Gerrit package.

Default: true

##### `package_name`
The name of the package to be installed.
Default: 'gerrit'

##### `version`
The Gerrit version to be installed. This is used to set the `ensure`
parameter to the package class to avoid unexpected package upgrades.

Default: '2.12.2'

##### `gerrit_home`
The path to the Gerrit base directory. The default matches the path
used by the gerrit-installer packages (e.g. the packages provided by
GerritForge). If you are using a custom package (or installing Gerrit
manually) you might have to change this.

Default: '/var/gerrit'

##### `user`
The name of the Gerrit user. The user is not managed by this package,
but some resources make use of it.

Default: 'gerrit'

##### `group`
The primary group of the Gerrit user. The group is not managed by this
package, but some resources make use of it.

Default: 'gerrit'

##### `gerrit_config`
Hash describing ini variables to be set in the gerrit.config file.
These are maintained by the puppetlabs-inifile module, which will
leave the remainder of the file unmodified. If you need to remove a
config variable, simply delete it from the gerrit.config file or add
it to the hash with `ensure: absent` as described in the inifile
documentation.

Default: {} (empty hash)

##### `secure_config`
Hash describing ini variables to be set in the secure.config file. See
the `gerrit_config` parameter for more details.

Default: {} (empty hash)

##### `extra_configs`
Hash describing extra config files to be created, in the format
`{ 'extrafile.config': { 'key': 'value'} }`. See the `gerrit_config`
parameter for more details.

Default: {} (empty hash)

##### `manage_db`
True if this module should manage the Gerrit database. The database
parameters are retrieved directly from the `gerrit_config` hash.
Currently it is only possible to add MySQL and PostgreSQL databases on
localhost, and either option requires the installation of the
puppetlabs-mysql or puppetlabs-postgresql module respectively.

Default: false

##### `manage_service`
True if this module should manage the Gerrit service. This includes
the actual service enable/disable/start/stop functionality, but also
ensures that the Gerrit site initialisation is run after any config
change. This _should_ be idempotent but verification in a test
environment would be wise.

Default: true

##### `service_name`
The name of the system service to be managed by this module.

Default: 'gerrit'

##### `service_ensure`
Tells Puppet whether the managed service should be running. Valid
options: 'running' or 'stopped'.

Default: 'running'

## Limitations

* The GerritForge repositories are only provided for RedHat- and Debian-based systems. Usage of this module is still possible with a manually-managed repository or manually-installed Gerrit, with `manage_repo` and/or `manage_package` set to `false`.
* Currently this module provides almost no customisation features - it is not possible to manage plugins or custom site content. However it also should not overwrite any manual customisations made.

## Development

All contributions welcome, particularly with tests attached.
