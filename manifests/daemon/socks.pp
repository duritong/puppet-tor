# socks definition
define tor::daemon::socks(
  $ensure   = 'present',
  $port     = 0,
  $policies = [],
) {
  if $ensure == 'present' {
    concat::fragment { '02.socks':
      content => template('tor/torrc.socks.erb'),
      order   => '02',
      target  => $tor::daemon::config_file,
    }
  }
}
