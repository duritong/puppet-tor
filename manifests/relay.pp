class tor::relay inherits tor::daemon {

  tor::daemon::config { "tor-relay":
                        socks_port             => 0,
                        socks_listen_addresses => [],
                        or_port                => 9001,
                        or_listen_address      => '',
                        nickname               => '',
                        address                => $hostname,
                        relay_bandwith_rate    => 0,
                        relay_bandwith_burst   => 0,
                        accounting_max         => 0,
                        accounting_start       => [],
                        contact_info           => '',
                        dir_port               => 0,
                        dir_listen_address     => '',
                        dir_front_page         => '',
                        my_family              => '',
                        exit_policies          => [],
                      }

} 
