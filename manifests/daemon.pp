# tor::daemon
class tor::daemon inherits tor {

  # config variables
  $data_dir    = '/var/tor'
  $config_file = '/etc/tor/torrc'
  $spool_dir   = '/var/lib/puppet/modules/tor'
  $snippet_dir = "${spool_dir}/torrc.d"

  # packages, user, group
  group { 'debian-tor':
    ensure    => present,
    allowdupe => false,
  }

  Package[ 'tor', 'torsocks' ] {
    require => File[$data_dir],
  }

  user { 'debian-tor':
    allowdupe => false,
    comment   => 'tor user,,,',
    ensure    => present,
    home      => $data_dir,
    shell     => '/bin/sh',
    gid       => 'debian-tor',
    require   => Group['debian-tor'], 
  }

  # directories
  file { "${data_dir}":
    ensure  => directory,
    mode    => 0755,
    owner   => 'debian-tor',
    group   => 'debian-tor',
    require => User['debian-tor'],
  }

  file { '/etc/tor':
    ensure  => directory,
    mode    => 0755,
    owner   => 'debian-tor',
    group   => 'debian-tor',
    require => User['debian-tor'],
  }

  file {"${spool_dir}":
    ensure => directory,
    owner => 'debian-tor', group => 'debian-tor', mode => 0755, 
  }

  file {"${snippet_dir}":
    ensure => directory,
    owner => 'debian-tor', group => 'debian-tor', mode => 0755, 
    require => File[$spool_dir],
  }

  # tor configuration file
  concatenated_file { "${config_file}":
    dir    => $snippet_dir,
    mode   => 0600,
    notify => Service['tor'],
    owner => 'debian-tor', group => 'debian-tor', 
  }

  # config file headers
  file { "${snippet_dir}/00.header":
    content => template('tor/torrc.header.erb'),
    require => File["${snippet_dir}"],
    notify  => Exec["concat_${config_file}"],
    ensure  => present,
    owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
  }

  # global configurations
  define global_opts( $data_dir = $data_dir,
                      $log_rules = [ 'notice file /var/log/tor/notices.log' ],
                      $ensure = present ) {
    file { "${tor::daemon::snippet_dir}/01.global":
      content => template('tor/torrc.global.erb'),
      require => File["${tor::daemon::snippet_dir}"],
      notify  => Exec["concat_${tor::daemon::config_file}"],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  }

  # socks definition
  define socks( $port = 0,
                $listen_addresses = [],
                $policies = [] ) {
    file { "${tor::daemon::snippet_dir}/02.socks":
      content => template('tor/torrc.socks.erb'),
      require => File["${tor::daemon::snippet_dir}"],
      notify  => Exec["concat_${tor::daemon::config_file}"],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  }

  # relay definition
  define relay( $port                  = 0,
                $listen_addresses      = [],
                $bandwidth_rate  = 0,  # KB/s, 0 for no limit.
                $bandwidth_burst = 0,  # KB/s, 0 for no limit.
                $accounting_max        = 0,  # GB, 0 for no limit.
                $accounting_start      = [],
                $contact_info          = '',
                $my_family             = '', # TODO: autofill with other relays
                $bridge_relay          = 0,
                $ensure                = present ) {
    $nickname = $name
    $address = $hostname

    file { "${tor::daemon::snippet_dir}/03.relay":
      content => template('tor/torrc.relay.erb'),
      require => File["${tor::daemon::snippet_dir}"],
      notify  => Exec["concat_${tor::daemon::config_file}"],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  } 

  # control definition
  define control( $port                    = 0,
                  $hashed_control_password = '',
                  $ensure                  = present ) {
    file { "${tor::daemon::snippet_dir}/04.control":
      content => template('tor/torrc.control.erb'),
      require => File["${tor::daemon::snippet_dir}"],
      notify  => Exec["concat_${tor::daemon::config_file}"],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0600, 
    }
  } 

  # hidden services definition
  define hidden_service( $ports = [],
                              $ensure = present ) {
    file { "${tor::daemon::snippet_dir}/05.hidden_service.${name}":
      content => template('tor/torrc.hidden_service.erb'),
      require => File["${tor::daemon::snippet_dir}"],
      notify  => Exec["concat_${tor::daemon::config_file}"],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  } 
  
  # directory advertising
  define directory ( $port = 0,
                     $listen_addresses = [],
                     $port_front_page = '',
                     $ensure = present ) {
    file { "${tor::daemon::snippet_dir}/06.directory":
      content => template('tor/torrc.directory.erb'),
      require => [ File["${tor::daemon::snippet_dir}"], File['/etc/tor/tor-exit-notice.html'] ],
      notify  => Exec["concat_${tor::daemon::config_file}"],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
    file { '/etc/tor/tor-exit-notice.html':
      source  => "puppet://$server/modules/tor/tor-exit-notice.html",
      require => File['/etc/tor'],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  } 

  # exit policies
  define exit_policy( $accept = [],
                      $reject = [],
                      $ensure = present ) {
    file { "${tor::daemon::snippet_dir}/07.exit_policy.${name}":
      content => template('tor/torrc.exit_policy.erb'),
      require => File["${tor::daemon::snippet_dir}"],
      notify  => Exec["concat_${tor::daemon::config_file}"],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  } 
}

