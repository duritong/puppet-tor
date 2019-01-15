# Bridge definition
define tor::daemon::bridge(
  Enum['present', 'absent'] $ensure = 'present',
  Stdlib::IP::Address $ip,
  Stdlib::Port $port,
  Boolean $fingerprint              = false,
) {
  if $ensure == 'present' {
    concat::fragment { "11.bridge.${name}":
      content => template('tor/torrc/11_bridge.erb'),
      order   => '11',
      target  => $tor::daemon::config_file,
    }
  }
}

