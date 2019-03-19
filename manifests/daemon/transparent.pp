# Transparent proxy definition
define tor::daemon::transparent(
  Enum['present', 'absent'] $ensure = 'present',
  Tor::Port $port                   = undef,
){
  if $ensure == 'present' {
    concat::fragment { "10.transparent.${name}":
      content => epp('tor/torrc/10_transparent.epp', {
        'port' => $tor::daemon::transparent::port,
      }),
      order   => '10',
      target  => $tor::config_file,
    }
  }
}
