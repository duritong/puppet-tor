# @summary Extend basic Tor configuration with a snippet based configuration.
#          DNS module.
#
# @param ensure
#   Whether this module should be used or not.
#
# @param port
#   Port to open in order to listen for UDP DNS requests and resolve them
#   anonymously.
#
define tor::daemon::dns(
  Enum['present', 'absent'] $ensure = 'present',
  Tor::Port $port                   = undef,
){
  if $ensure == 'present' {
    concat::fragment { "08.dns.${name}":
      content => epp('tor/torrc/08_dns.epp', {
        'port' => $port,
      }),
      order   => '08',
      target  => $tor::config_file,
    }
  }
}
