class tor::daemon (
  $data_dir                 = '/var/lib/tor',
  $config_file              = '/etc/tor/torrc',
  $use_bridges              = 0,
  $automap_hosts_on_resolve = 0,
  $log_rules                = [ 'notice file /var/log/tor/notices.log' ],
) inherits tor {

  # constants
  $spool_dir   = '/var/lib/puppet/modules/tor'

  # packages, user, group
  Service['tor'] {
    subscribe => File["${config_file}"],
  }

  Package[ 'tor' ] {
    require => File["${data_dir}"],
  }

  group { 'debian-tor':
    ensure    => present,
    allowdupe => false,
  }

  user { 'debian-tor':
    allowdupe => false,
    comment   => 'tor user,,,',
    ensure    => present,
    home      => "${data_dir}",
    shell     => '/bin/false',
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
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  # tor configuration file
  concat { "${config_file}":
    mode   => 0600,
    owner => 'debian-tor', group => 'debian-tor', 
  }

  # config file headers
  concat::fragment { '00.header':
    content => template('tor/torrc.header.erb'),
    owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    ensure  => present,
    order   => 00,
    target  => "${config_file}",
  }

  # global configurations
  concat::fragment { '01.global':
    content => template('tor/torrc.global.erb'),
    owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
    order   => 01,
    target  => "${config_file}",
  }

  # socks definition
  define socks( $port = 0,
                $listen_addresses = [],
                $policies = [] ) {

    concat::fragment { '02.socks':
      content => template('tor/torrc.socks.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      order   => 02,
      target  => "${tor::daemon::config_file}",
    }
  }

  # relay definition
  define relay( $port                    = 0,
                $listen_addresses        = [],
                $outbound_bindaddresses  = [],
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

    if $outbound_bindaddresses == [] {
      $real_outbound_bindaddresses = $listen_addresses
    } else {
      $real_outbound_bindaddresses = $outbound_bindaddresses
    }

    concat::fragment { '03.relay':
      content => template('tor/torrc.relay.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
      order   => 03,
      target  => "${tor::daemon::config_file}",
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
      fail('You need to define the tor control password')
    }

    if $cookie_authentication == 0 and ("${cookie_auth_file}" != '' or "${cookie_auth_file_group_readable}" != '') {
      notice('You set a tor cookie authentication option, but do not have cookie_authentication on')
    }
    
    concat::fragment { '04.control':
      content => template('tor/torrc.control.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0600, 
      ensure  => $ensure,
      order   => 04,
      target  => "${tor::daemon::config_file}",
    }
  } 

  # hidden services definition
  define hidden_service( $ports = [],
                         $data_dir = "${tor::daemon::data_dir}",
                         $ensure = present ) {

    concat::fragment { "05.hidden_service.${name}":
      content => template('tor/torrc.hidden_service.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
      order   => 05,
      target  => "${tor::daemon::config_file}",
    }
  } 
  
  # directory advertising
  define directory ( $port = 0,
                     $listen_addresses = [],
                     $port_front_page = '/etc/tor/tor.html',
                     $ensure = present ) {

    concat::fragment { '06.directory':
      content => template('tor/torrc.directory.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
      order   => 06,
      target  => "${tor::daemon::config_file}",
    }
    
    file { '/etc/tor/tor.html':
      source  => 'puppet:///modules/tor/tor.html',
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

    concat::fragment { "07.exit_policy.${name}":
      content => template('tor/torrc.exit_policy.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644, 
      ensure  => $ensure,
      order   => 07,
      target  => "${tor::daemon::config_file}",
    }
  } 

  # DNS definition
  define dns( $port = 0,
              $listen_addresses = [],
              $ensure = present ) {

    concat::fragment { "08.dns.${name}":
      content => template('tor/torrc.dns.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644,
      ensure  => $ensure,
      order   => 08,
      target  => "${tor::daemon::config_file}",
    }
  }

  # Transparent proxy definition
  define transparent( $port = 0,
                      $listen_addresses = [],
                      $ensure = present ) {

    concat::fragment { "09.transparent.${name}":
      content => template('tor/torrc.transparent.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644,
      ensure  => $ensure,
      order   => 09,
      target  => "${tor::daemon::config_file}",
    }
  }

  # Bridge definition
  define bridge( $ip,
                 $port,
                 $fingerprint = false,
                 $ensure = present ) {

    concat::fragment { "10.bridge.${name}":
      content => template('tor/torrc.bridge.erb'),
      owner => 'debian-tor', group => 'debian-tor', mode => 0644,
      ensure  => $ensure,
      order   => 10,
      target  => "${tor::daemon::config_file}",
    }
  }

  # map address definition
  define map_address( $address = '',
                      $newaddress = '') {

    concat::fragment { "08.map_address.${name}":
      content => template('tor/torrc.map_address.erb'),
      owner   => 'debian-tor', group => 'debian-tor', mode => 0644,
      ensure  => $ensure,
      order   => 08,
      target  => "${tor::daemon::config_file}",
    }
  }

  # Arbitrary torrc snippet definition
  define snippet( $content = '',
                  $ensure = present ) {

    concat::fragment { "99.snippet.${name}":
      content => "${content}",
      owner   => 'debian-tor', group => 'debian-tor', mode => 0644,
      ensure  => $ensure,
      order   => 99,
      target  => "${tor::daemon::config_file}",
    }
  }

}
