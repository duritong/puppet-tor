class tor {
  package { "privoxy":
    ensure => absent,
  }

  package { [ "tor", "polipo", "torsocks" ]:
    ensure => installed,
  }

  service { "tor":
    ensure  => running,
    require => [ Package['tor'], Service["polipo"] ],
  }

  service { "polipo":
    ensure  => running,
    require => Package["polipo"],
  }

  file { "/etc/polipo":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  file { "/etc/polipo/config":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet://$server/modules/tor/polipo.conf",
    notify  => Service["polipo"],
    require => File["/etc/polipo"],
  }

  # TODO: restore file to original state after the following bug is solved:
  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=580434
  file { "/etc/cron.daily/polipo":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    source  => "puppet://$server/modules/tor/polipo.cron",
  }

  define config( $socks_port = 9050,
                 $socks_listen_addresses = [ '127.0.0.1' ],
                 $socks_policies = [ 'accept 127.0.0.1/16', 'reject *' ],
                 $log_rules = [ 'notice file /var/log/tor/notices.log' ],
                 $data_directory = '/var/tor',
                 $control_port = false,
                 $hashed_control_password = '',
                 $hidden_services = [],
                 $or_port = 443,
                 $or_listen_address = '0.0.0.0:9090',
                 $nickname = '',
                 $address = $hostname,
                 $relay_bandwith_rate = 0,  # KB/s, 0 for no limit.
                 $relay_bandwith_burst = 0, # KB/s, 0 for no limit.
                 $accounting_max = 0,       # GB, 0 for no limit.
                 $accounting_start = [],
                 $contact_info = '',
                 $dir_port = 0,
                 $dir_listen_address = '',
                 $dir_front_page = '',
                 $my_family = '',
                 $exit_policies = [],
                 ) {
    file { "/etc/tor/torrc":
      ensure  => present,
      content => template('tor/torrc.erb'),
      owner   => root,
      group   => root,
      mode    => 0644,
    }
  }
}
