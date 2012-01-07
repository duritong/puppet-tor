class tor::bridge inherits tor::daemon {

  tor::daemon::config { "tor-bridge-$name":
                        socks_port             => 0,
                        socks_listen_addresses => [],
                        socks_policies         => [],
                        log_rules              => [],
                        hidden_services        => [],
                        or_port                => 443,
                        address                => '',
                        relay_bandwith_rate    => 0,
                        relay_bandwith_burst   => 0,
                        exit_policies          => 'reject *:*',
                        bridge_relay           => 1,
                      }

}
