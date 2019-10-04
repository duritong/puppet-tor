# @summary Extend basic Tor configuration with a snippet based configuration.
#          Relay definition module.
#
# @example A simple relay example
#   tor::daemon::relay { 'foobar':
#     port             => '9001',
#     address          => '192.168.0.1',
#     bandwidth_rate   => '256',
#     bandwidth_burst  => '256',
#     contact_info     => "Foo <collective at example dot com>",
#     my_family        => '<long family string here>';
#   }
#
# @param ensure
#   Whether this module should be used or not.
#
# @param port
#   The ORPort the relay should use.
#
# @param outbound_bindaddresses
#   Make all outbound connections originate from the IP address specified.
#
# @param nickname
#   The relays's nickname.
#
# @param address
#   The relay's IP address.
#
# @param bandwith_rate
#   Maximum bandwidth rate in KB/s for the relay.
#
# @param bandwith_burst
#   Maximum bandwidth burst rate in KB/s for the relay.
#
# @param relay_bandwith_rate
#   Maximum relayed bandwidth rate in KB/s.
#
# @param relay_bandwith_burst
#   Maximum relayed bandwidth burst rate in KB/s.
#
# @param accounting_max
#   Limits the max number of bytes sent and received within a set time period.
#
# @param accounting_start
#   Specify how long accounting periods last.
#
# @param contact_info
#   Administrative contact email address for the relay.
#
# @param my_family
#   Declare that this Tor relay is controlled or administered by a group or
#   organization identical or similar to that of the other relays.
#
# @param bridge_relay
#   Make this relay a bridge.
#
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
