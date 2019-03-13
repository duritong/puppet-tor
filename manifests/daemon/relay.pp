# relay definition
define tor::daemon::relay(
  Enum['present', 'absent'] $ensure                            = 'present',
  Variant[0, Stdlib::Port] $port                               = 0,
  Optional[Array[Stdlib::IP::Address]] $outbound_bindaddresses = undef,
  Optional[String] $nickname                                   = undef,
  Stdlib::Fqdn $address                                        = "tor.${::domain}",
  Stdlib::Port $portforwarding                                 = 0,
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
        'port'                   => $tor::daemon::relay::port,
        'outbound_bindaddresses' => $tor::daemon::relay::outbound_bindaddresses,
        'nickname'               => $tor::daemon::relay::nickname,
        'address'                => $tor::daemon::relay::address,
        'portforwarding'         => $tor::daemon::relay::portforwarding,
        'bandwidth_rate'         => $tor::daemon::relay::bandwidth_rate,
        'bandwidth_burst'        => $tor::daemon::relay::bandwidth_burst,
        'relay_bandwidth_rate'   => $tor::daemon::relay::relay_bandwidth_rate,
        'relay_bandwidth_burst'  => $tor::daemon::relay::relay_bandwidth_burst,
        'accounting_max'         => $tor::daemon::relay::accounting_max,
        'accounting_start'       => $tor::daemon::relay::accounting_start,
        'contact_info'           => $tor::daemon::relay::contact_info,
        'my_family'              => $tor::daemon::relay::my_family,
        'bridge_relay'           => $tor::daemon::relay::bridge_relay,
      }),
      order   => '03',
      target  => $tor::daemon::config_file,
    }
  }
}
