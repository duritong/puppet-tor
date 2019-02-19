# socks definition
define tor::daemon::socks(
  Enum['present', 'absent'] $ensure = 'present',
  Stdlib::Port $port  = 0,
  Array[String] $policies,
) {
  if $ensure == 'present' {
    concat::fragment { '02.socks':
      content => epp('tor/torrc/02_socks.epp', {
        'port'     => $tor::daemon::socks::port,
        'policies' => $tor::daemon::socks::policies,
      }),
      order   => '02',
      target  => $tor::daemon::config_file,
    }
  }
}
