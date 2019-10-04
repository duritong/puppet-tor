# @summary Extend basic Tor configuration with a snippet based configuration.
#          Use a Tor Bridge to connect to Tor.
#
# @param ensure
#   Whether this module should be used or not.
#
# @param ip
#   The IP address of the bridge that will be used.
#
# @param port
#   The IP port of the bridge that will be used.
#
# @param fingerprint
#   Fingerprint of the Tor Bridge to verify that the relay running at that
#   location has the right fingerprint.
#
# @param transport
#   What pluggable transport’s proxy to use to transfer data to the bridge.
#
define tor::daemon::bridge(
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Stdlib::IP::Address] $ip = undef,
  Optional[Stdlib::Port] $port      = undef,
  Optional[String] $fingerprint     = undef ,
  Optional[String] $transport       = undef ,
) {
  unless $ip or $port {
    fail('You need to specify an IP address ($tor::daemon::bridge::ip) AND a port number ($tor::daemon::bridge::port)')
  }
  if $ensure == 'present' {
    concat::fragment { "11.bridge.${name}":
      content => epp('tor/torrc/11_bridge.epp', {
        'name'        => $name,
        'ip'          => $ip,
        'port'        => $port,
        'fingerprint' => $fingerprint,
        'transport'   => $transport,
      }),
      order   => '11',
      target  => $tor::config_file,
    }
  }
}

