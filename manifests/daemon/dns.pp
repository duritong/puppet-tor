# DNS definition
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
