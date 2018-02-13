# relay definition
define tor::daemon::relay(
  $ensure                  = 'present',
  $port                    = 0,
  $outbound_bindaddresses  = [],
  $portforwarding          = 0,
  # KB/s, defaulting to using tor's default: 5120KB/s
  $bandwidth_rate          = '',
  # KB/s, defaulting to using tor's default: 10240KB/s
  $bandwidth_burst         = '',
  # KB/s, 0 for no limit
  $relay_bandwidth_rate    = 0,
  # KB/s, 0 for no limit
  $relay_bandwidth_burst   = 0,
  # GB, 0 for no limit
  $accounting_max          = 0,
  $accounting_start        = 'month 1 0:00',
  $contact_info            = '',
  # TODO: autofill with other relays
  $my_family               = '',
  $address                 = "tor.${::domain}",
  $bridge_relay            = 0,
) {

  if $ensure == 'present' {
    $nickname = $name

    if $outbound_bindaddresses == [] {
      $real_outbound_bindaddresses = []
    } else {
      $real_outbound_bindaddresses = $outbound_bindaddresses
    }

    concat::fragment { '03.relay':
      content => template('tor/torrc.relay.erb'),
      order   => '03',
      target  => $tor::daemon::config_file,
    }
  }
}
