# DNS definition
define tor::daemon::dns(
  Enum['present', 'absent'] $ensure = 'present',
  Stdlib::Port $port  = 0,
){
  if $ensure == 'present' {
    concat::fragment { "08.dns.${name}":
      content => template('tor/torrc/08_dns.erb'),
      order   => '08',
      target  => $tor::daemon::config_file,
    }
  }
}

