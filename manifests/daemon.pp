class tor::daemon (
  $data_dir                 = '/var/lib/tor',
  $config_file              = '/etc/tor/torrc',
  $use_bridges              = 0,
  $automap_hosts_on_resolve = 0,
  $log_rules                = [ 'notice file /var/log/tor/notices.log' ]
) inherits tor {

  # packages, user, group
  Service['tor'] {
    subscribe => File[$config_file],
  }

  Package[ 'tor' ] {
    require => File[$data_dir],
  }

  group { 'debian-tor':
    ensure    => present,
    allowdupe => false,
  }

  user { 'debian-tor':
    ensure    => present,
    allowdupe => false,
    comment   => 'tor user,,,',
    home      => $data_dir,
    shell     => '/bin/false',
    gid       => 'debian-tor',
    require   => Group['debian-tor'],
  }

  # directories
  file { $data_dir:
    ensure  => directory,
    mode    => '0700',
    owner   => 'debian-tor',
    group   => 'debian-tor',
    require => User['debian-tor'],
  }

  file { '/etc/tor':
    ensure  => directory,
    mode    => '0755',
    owner   => 'debian-tor',
    group   => 'debian-tor',
    require => User['debian-tor'],
  }

  file { '/var/lib/puppet/modules/tor':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  # tor configuration file
  concat { $config_file:
    mode   => '0600',
    owner  => 'debian-tor',
    group  => 'debian-tor',
  }

  # config file headers
  concat::fragment { '00.header':
    ensure  => present,
    content => template('tor/torrc.header.erb'),
    owner   => 'debian-tor', group => 'debian-tor', mode => '0644',
    order   => 00,
    target  => $config_file,
  }

  # global configurations
  concat::fragment { '01.global':
    content => template('tor/torrc.global.erb'),
    owner   => 'debian-tor', group => 'debian-tor', mode => '0644',
    order   => 01,
    target  => $config_file,
  }
}
