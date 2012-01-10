# tor::daemon
class tor::daemon inherits tor::polipo {

  group { "debian-tor":
    ensure    => present,
    allowdupe => false,
  }

  Package[ "tor", "torsocks" ] {
    require => File["/var/tor"],
  }

  user { "debian-tor":
    allowdupe => false,
    comment   => "tor user,,,",
    ensure    => present,
    home      => "/var/tor",
    shell     => "/bin/sh",
    gid       => "debian-tor",
    require   => Group["debian-tor"], 
  }

  file { "/var/tor":
    ensure  => directory,
    mode    => 0755,
    owner   => debian-tor,
    group   => debian-tor,
    require => User["debian-tor"],
  }

  file { "/etc/tor":
    ensure  => directory,
    mode    => 0755,
    owner   => debian-tor,
    group   => debian-tor,
    require => User["debian-tor"],
  }

  file { "/etc/tor.d":
    ensure  => directory,
    mode    => 0755,
    owner   => debian-tor,
    group   => debian-tor,
    require => User["debian-tor"],
  }

  # configuration file
  define config(                 $log_rules = [ 'notice file /var/log/tor/notices.log' ],
                 $data_directory = '/var/tor',
                 $hidden_services = [],
                 $dir_port = 0,
                 $dir_listen_address = '',
                 $dir_port_front_page = '',
                 $exit_policies = [],
                 $bridge_relay = 0) {

  }

  concatenated_file { "/etc/tor/torrc":
    dir    => '/etc/tor.d',
    mode   => 0600,
    notify => Service["tor"],
  }

  exec { "rm -f /etc/tor.d/*":
      alias => 'clean-tor.d',
  }

  # socks definition
  define tor::socks( $socks_port = 9050,
                     $socks_listen_addresses = [ '127.0.0.1' ],
                     $socks_policies = [ 'accept 127.0.0.1/16', 'reject *' ], ) {
    file { "/etc/tor.d/01.socks":
      require => File['/etc/tor.d'],
      notify  => Exec['concat_/etc/tor/torrc'],
      ensure  => $ensure,
      require => Exec['clean-tor.d'],
    }
  }

  # relay definition
  define tor::relay( $port                  = 0,
                     $listen_address        = '',
                     $nickname              = '',
                     $address               = $hostname,
                     $relay_bandwidth_rate  = 0,  # KB/s, 0 for no limit.
                     $relay_bandwidth_burst = 0, # KB/s, 0 for no limit.
                     $accounting_max        = 0,       # GB, 0 for no limit.
                     $accounting_start      = [],
                     $contact_info          = '',
                     $my_family             = '',
                     $ensure                = absent, ) {

    file { "/etc/tor.d/02.relay":
      require => File['/etc/tor.d'],
      notify  => Exec['concat_/etc/tor/torrc'],
      ensure  => $ensure,
      require => Exec['clean-tor.d'],
    }
  } 

  # control definition
  define tor::control( $port                    = 0,
                       $hashed_control_password = '',
                       $ensure                  = absent ) {
    file { "/etc/tor.d/03.control":
      require => File['/etc/tor.d'],
      notify  => Exec['concat_/etc/tor/torrc'],
      ensure  => $ensure,
      require => Exec['clean-tor.d'],
    }
  } 

  # hidden services definition
  define tor::hidden_service( $ports = [],
                              $ensure = present ) {
    file { "/etc/tor.d/04.hidden_service.$name":
      require => File['/etc/tor.d'],
      notify  => Exec['concat_/etc/tor/torrc'],
      ensure  => $ensure,
      require => Exec['clean-tor.d'],
    }
  } 
  
  # directory advertising
  define tor::directory ( $ports = [],
                          $hashed_password = '',
                          $ensure = present, ) {
    file { "/etc/tor.d/05.directory":
      require => File['/etc/tor.d'],
      notify  => Exec['concat_/etc/tor/torrc'],
      ensure  => $ensure,
      require => Exec['clean-tor.d'],
    }
  } 

  # exit policies
  define tor::exit_policy( $accept = [],
                           $reject = [],
                           $ensure = present, ) {
    file { "/etc/tor.d/06.exit_policy":
      require => File['/etc/tor.d'],
      notify  => Exec['concat_/etc/tor/torrc'],
      ensure  => $ensure,
      require => Exec['clean-tor.d'],
    }
  } 
}

