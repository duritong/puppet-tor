# tor::daemon
class tor::daemon inherits tor {

  # config variables
  $data_dir    = '/var/lib/tor'
  $config_file = '/etc/tor/torrc'
  $spool_dir   = '/var/lib/puppet/modules/tor'
  $snippet_dir = "${spool_dir}/torrc.d"

  # packages, user, group
  Service['tor'] {
    subscribe => File[$config_file],
  }

  Package[ 'tor', 'torsocks' ] {
    require => File[$data_dir],
  }

  group { 'debian-tor':
    ensure    => present,
    allowdupe => false,
  }

  user { 'debian-tor':
    allowdupe => false,
    comment   => 'tor user,,,',
    ensure    => present,
    home      => $data_dir,
    shell     => '/bin/bash',
    gid       => 'debian-tor',
    require   => Group['debian-tor'], 
  }

  # directories
  file { "${data_dir}":
    ensure  => directory,
    mode    => 0700,
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

  file { "${spool_dir}":
    ensure => directory,
    owner => 'debian-tor', group => 'debian-tor', mode => 0755, 
  }

  file { "${snippet_dir}":
    ensure => directory,
    owner => 'debian-tor', group => 'debian-tor', mode => 0755, 
    require => File[$spool_dir],
  }

  # tor configuration file
  concatenated_file { "${config_file}":
    dir    => $snippet_dir,
    mode   => 0600,
    owner => 'debian-tor', group => 'debian-tor', 
  }

  # config file headers
  concatenated_file_part { '00.header':
    dir     => $snippet_dir,
    content => template('tor/torrc.header.erb'),
    owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    ensure  => present,
  }

  # global configurations
  define global_opts( $data_dir = $tor::daemon::data_dir,
                      $log_rules = [ 'notice file /var/log/tor/notices.log' ] ) {

    concatenated_file_part { '01.global':
      dir     => $tor::daemon::snippet_dir,
      content => template('tor/torrc.global.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  }

  # socks definition
  define socks( $port = 0,
                $listen_addresses = [],
                $policies = [] ) {

    concatenated_file_part { '02.socks':
      dir     => $tor::daemon::snippet_dir,
      content => template('tor/torrc.socks.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  }

  # relay definition
  define relay( $port                    = 0,
                $listen_addresses        = [],
                $outbound_bindaddresses  = $listen_addresses,
                $bandwidth_rate          = '',    # KB/s, defaulting to using tor's default: 5120KB/s
                $bandwidth_burst         = '',    # KB/s, defaulting to using tor's default: 10240KB/s
                $relay_bandwidth_rate    = 0,     # KB/s, 0 for no limit.
                $relay_bandwidth_burst   = 0,     # KB/s, 0 for no limit.
                $accounting_max          = 0,     # GB, 0 for no limit.
                $accounting_start        = [],
                $contact_info            = '',
                $my_family               = '', # TODO: autofill with other relays
                $address                 = "tor.${domain}",
                $bridge_relay            = 0,
                $ensure                  = present ) {
    $nickname = $name

    concatenated_file_part { '03.relay':
      dir     => $tor::daemon::snippet_dir,
      content => template('tor/torrc.relay.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
    }
  } 

  # control definition
  define control( $port                            = 0,
                  $hashed_control_password         = '',
                  $cookie_authentication           = 0,
                  $cookie_auth_file                = '',
                  $cookie_auth_file_group_readable = '',
                  $ensure                  = present ) {

    if $cookie_authentication == '0' and $hashed_control_password == '' and $ensure != 'absent' {
      fail("You need to define the tor control password")
    }

    if $cookie_authentication == 0 and ($cookie_auth_file != '' or $cookie_auth_file_group_readable != '') {
      notice("You set a tor cookie authentication option, but do not have cookie_authentication on")
    }
    
    concatenated_file_part { '04.control':
      dir     => $tor::daemon::snippet_dir,
      content => template('tor/torrc.control.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0600, 
      ensure  => $ensure,
    }
  } 

  # hidden services definition
  define hidden_service( $ports = [],
                         $data_dir = $tor::daemon::data_dir,
                         $ensure = present ) {

    concatenated_file_part { "05.hidden_service.${name}":
      dir     => $tor::daemon::snippet_dir,
      content => template('tor/torrc.hidden_service.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
    }
  } 
  
  # directory advertising
  define directory ( $port = 0,
                     $listen_addresses = [],
                     $port_front_page = '/etc/tor/tor.html',
                     $ensure = present ) {

    concatenated_file_part { '06.directory':
      dir     => $tor::daemon::snippet_dir,
      content => template('tor/torrc.directory.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
    }
    
    file { '/etc/tor/tor.html':
      source  => "puppet:///modules/tor/tor.html",
      require => File['/etc/tor'],
      ensure  => $ensure,
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    }
  } 

  # exit policies
  define exit_policy( $accept = [],
                      $reject = [],
                      $reject_private = 1,
                      $ensure = present ) {

    concatenated_file_part { "07.exit_policy.${name}":
      dir     => $tor::daemon::snippet_dir,
      content => template('tor/torrc.exit_policy.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
    }
  } 
}

