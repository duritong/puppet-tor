define tor::daemon::relay(
  Enum['present', 'absent'] $ensure                            = 'present',
  Optional[Tor::Port] $port                                    = undef,
  Optional[Array[Stdlib::IP::Address]] $outbound_bindaddresses = undef,
  Optional[String] $nickname                                   = undef,
  Stdlib::Fqdn $address                                        = "tor.${::domain}",
  Optional[Integer] $bandwidth_rate                            = undef,
  Optional[Integer] $bandwidth_burst                           = undef,
  Optional[Integer] $relay_bandwidth_rate                      = undef,
  Optional[Integer] $relay_bandwidth_burst                     = undef,
  Optional[Integer] $accounting_max                            = undef,
  String $accounting_start                                     = 'month 1 0:00',
  Optional[String] $contact_info                               = undef,
  Optional[String] $my_family                                  = undef,
  Boolean $bridge_relay                                        = false,
) {

  if $ensure == 'present' {

    concat::fragment { '03.relay':
      content => epp('tor/torrc/03_relay.epp', {
        'port'                   => $port,
        'outbound_bindaddresses' => $outbound_bindaddresses,
        'nickname'               => $nickname,
        'address'                => $address,
        'bandwidth_rate'         => $bandwidth_rate,
        'bandwidth_burst'        => $bandwidth_burst,
        'relay_bandwidth_rate'   => $relay_bandwidth_rate,
        'relay_bandwidth_burst'  => $relay_bandwidth_burst,
        'accounting_max'         => $accounting_max,
        'accounting_start'       => $accounting_start,
        'contact_info'           => $contact_info,
        'my_family'              => $my_family,
        'bridge_relay'           => $bridge_relay,
      }),
      order   => '03',
      target  => $tor::config_file,
    }
  }
}
