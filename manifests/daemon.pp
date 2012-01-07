class tor::daemon inherits tor {

  include polipo

  service { "tor":
    ensure  => running,
    require => [ Package['tor'], Service["polipo"] ],
  }

  define config( $socks_port = 9001,
                 $socks_listen_addresses = [ '127.0.0.1' ],
                 $socks_policies = [ 'accept 127.0.0.1/16', 'reject *' ],
                 $log_rules = [ 'notice file /var/log/tor/notices.log' ],
                 $data_directory = '/var/tor',
                 $control_port = false,
                 $hashed_control_password = '',
                 $hidden_services = [],
                 $or_port = 0,
                 $or_listen_address = '',
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
                 $bridge_relay = 0) {

    file { "/etc/tor/torrc":
      ensure  => present,
      content => template('tor/torrc.erb'),
      owner   => root,
      group   => root,
      mode    => 0644,
    }
  }

}
