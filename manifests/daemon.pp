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

  define config( $socks_port = 9050,
                 $socks_listen_addresses = [ '127.0.0.1' ],
                 $socks_policies = [ 'accept 127.0.0.1/16', 'reject *' ],
                 $log_rules = [ 'notice file /var/log/tor/notices.log' ],
                 $data_directory = '/var/tor',
                 $control_port = 0,
                 $hashed_control_password = '',
                 $hidden_services = [],
                 $or_port = 0,
                 $or_listen_address = '',
                 $nickname = '',
                 $address = $hostname,
                 $relay_bandwidth_rate = 0,  # KB/s, 0 for no limit.
                 $relay_bandwidth_burst = 0, # KB/s, 0 for no limit.
                 $accounting_max = 0,       # GB, 0 for no limit.
                 $accounting_start = [],
                 $contact_info = '',
                 $dir_port = 0,
                 $dir_listen_address = '',
                 $dir_port_front_page = '',
                 $my_family = '',
                 $exit_policies = [],
                 $bridge_relay = 0) {

    file { "/etc/tor/torrc":
      ensure  => present,
      content => template('tor/torrc.erb'),
      owner   => root,
      group   => root,
      mode    => 0644,
      notify  => Service["tor"],
    }
  }

}
