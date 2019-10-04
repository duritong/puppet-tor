# @summary Extend basic Tor configuration with a snippet based configuration.
#          Base module.
#
# @param user
#   Unix user for the tor process.
#
# @param group
#   Unix group for the tor process.
#
# @param manage_user
#   If Puppet should manage the tor process unix user and group
#
# @param data_dir_mode
#   Unix mode for the tor data directory.
#
class tor::daemon::base (
  String $user                    = $tor::daemon::params::user,
  String $group                   = $tor::daemon::params::group,
  Boolean $manage_user            = $tor::daemon::params::manage_user,
  Stdlib::Filemode $data_dir_mode = $tor::daemon::params::data_dir_mode
) inherits tor::daemon::params {

  if $tor::daemon::params::manage_user {
    group { $tor::daemon::params::group:
      ensure    => present,
      allowdupe => false,
    }

    user { $tor::daemon::params::user:
      ensure    => present,
      allowdupe => false,
      comment   => 'tor user,,,',
      home      => $tor::data_dir,
      shell     => '/bin/false',
      gid       => $tor::daemon::params::group,
      require   => Group[$tor::daemon::params::group],
    }
  }

  # directories
  file { $tor::data_dir:
    ensure  => directory,
    mode    => $tor::daemon::params::data_dir_mode,
    owner   => $tor::daemon::params::user,
    group   => 'root',
    require => Package['tor'],
  }

  file { '/etc/tor':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Package['tor'],
  }

  # tor configuration file
  concat { $tor::config_file:
    mode    => '0640',
    owner   => 'root',
    group   => $tor::daemon::params::group,
    require => Package['tor'],
    notify  => Service['tor'],
  }

  # config file headers
  concat::fragment { '00.header':
    content => epp('tor/torrc/00_header.epp'),
    order   => '00',
    target  => $tor::config_file,
  }

  # global configurations
  concat::fragment { '01.global':
    content => epp('tor/torrc/01_global.epp', {
      'automap_hosts_on_resolve' => $tor::automap_hosts_on_resolve,
      'data_dir'                 => $tor::data_dir,
      'log_rules'                => $tor::log_rules,
      'safe_logging'             => $tor::safe_logging,
      'use_bridges'              => $tor::use_bridges,
    }),
    order   => '01',
    target  => $tor::config_file,
  }
}
