# Transparent proxy definition
define tor::daemon::transparent(
  $ensure           = 'present',
  $port             = 0) {

  if $ensure == 'present' {
    concat::fragment { "09.transparent.${name}":
      content => template('tor/torrc.transparent.erb'),
      order   => '09',
      target  => $tor::daemon::config_file,
    }
  }
}

