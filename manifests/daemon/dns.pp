# DNS definition
define tor::daemon::dns(
  $ensure           = 'present',
  $port             = 0,
){
  if $ensure == 'present' {
    concat::fragment { "08.dns.${name}":
      content => template('tor/torrc.dns.erb'),
      order   => '08',
      target  => $tor::daemon::config_file,
    }
  }
}

