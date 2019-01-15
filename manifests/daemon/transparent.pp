# Transparent proxy definition
define tor::daemon::transparent(
  $ensure           = 'present',
  $port             = 0) {

  if $ensure == 'present' {
    concat::fragment { "10.transparent.${name}":
      content => template('tor/torrc/10_transparent.erb'),
      order   => '10',
      target  => $tor::daemon::config_file,
    }
  }
}

