# Bridge definition
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
        'ip'          => $tor::daemon::bridge::ip,
        'port'        => $tor::daemon::bridge::port,
        'fingerprint' => $tor::daemon::bridge::fingerprint,
        'transport'   => $tor::daemon::bridge::transport,
      }),
      order   => '11',
      target  => $tor::config_file,
    }
  }
}

