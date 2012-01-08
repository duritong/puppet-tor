class tor::relay inherits tor::daemon {

  tor::daemon::config { "tor-relay":
                        socks_port             => 0,
                        socks_listen_addresses => [],
                        socks_policies         => [],
                        or_port                => 9001,
                        or_listen_address      => '',
                        nickname               => '',
                        address                => '',
                        relay_bandwidth_rate   => 50,
                        relay_bandwidth_burst  => 50,
                        accounting_max         => 0,
                        accounting_start       => [],
                        contact_info           => '',
                        dir_port               => 0,
                        dir_listen_address     => '',
                        dir_port_front_page    => '',
                        my_family              => '',
                        exit_policies          => [ 'reject *:*' ],
                      }

} 
