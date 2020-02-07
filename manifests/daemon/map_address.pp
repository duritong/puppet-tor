# @summary Extend basic Tor configuration with a snippet based configuration.
#          Map address module.
#
# @param ensure
#   Whether this module should be used or not.
#
# @param address
#   Incoming address to pass through the Map Address.
#
# @param newaddress
#   Outcoming address to pass through the Map Address.
#
define tor::daemon::map_address(
  Enum['present', 'absent'] $ensure  = 'present',
  Optional[Stdlib::Host] $address    = undef,
  Optional[Stdlib::Host] $newaddress = undef,
) {
  if $ensure == 'present' {
    concat::fragment { "09.map_address.${name}":
      content => epp('tor/torrc/09_map_address.epp', {
        'name'       => $name,
        'address'    => $address,
        'newaddress' => $newaddress,
      }),
      order   => '09',
      target  => $tor::config_file,
    }
  }
}
