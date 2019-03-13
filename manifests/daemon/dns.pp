# DNS definition
define tor::daemon::dns(
  Enum['present', 'absent'] $ensure = 'present',
  Variant[0, Stdlib::Port] $port    = 0,
){
  if $ensure == 'present' {
    concat::fragment { "08.dns.${name}":
      content => epp('tor/torrc/08_dns.epp', {
        'port' => $tor::daemon::dns::port,
      }),
      order   => '08',
      target  => $tor::config_file,
    }
  }
}
