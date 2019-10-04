# @summary Extend basic Tor configuration with a snippet based configuration.
#          Transparent Proxy module.
#
# @param ensure
#   Whether this module should be used or not.
#
# @param port
#   The TransPort.
#
define tor::daemon::transparent(
  Enum['present', 'absent'] $ensure = 'present',
  Tor::Port $port                   = undef,
){
  if $ensure == 'present' {
    concat::fragment { "10.transparent.${name}":
      content => epp('tor/torrc/10_transparent.epp', {
        'port' => $port,
      }),
      order   => '10',
      target  => $tor::config_file,
    }
  }
}
