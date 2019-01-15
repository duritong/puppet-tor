# Bridge definition
define tor::daemon::bridge(
  $ip,
  $port,
  $fingerprint = false,
  $ensure      = 'present',
) {
  if $ensure == 'present' {
    concat::fragment { "11.bridge.${name}":
      content => template('tor/torrc/11_bridge.erb'),
      order   => '11',
      target  => $tor::daemon::config_file,
    }
  }
}

