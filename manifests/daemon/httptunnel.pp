# @summary Extend basic Tor configuration with a snippet based configuration.
#          HTTPTunnel module.
#
# @param ensure
#   Whether this module should be used or not.
#
# @param port
#   Open this port to listen for proxy connections using the "HTTP CONNECT"
#   protocol instead of SOCKS.
#
define tor::daemon::httptunnel(
  Enum['present', 'absent'] $ensure = 'present',
  Tor::Port $port                   = undef,
){
  if $ensure == 'present' {
    concat::fragment { "13.httptunnel.${name}":
      content => epp('tor/torrc/13_httptunnel.epp', {
        'port' => $port,
      }),
      order   => '13',
      target  => $tor::config_file,
    }
  }
}
