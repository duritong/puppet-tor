# socks definition
define tor::daemon::socks(
  Enum['present', 'absent'] $ensure = 'present',
  Tor::Port $port                   = undef,
  Optional[Array[String]] $policies = undef,
) {
  if $ensure == 'present' {
    concat::fragment { '02.socks':
      content => epp('tor/torrc/02_socks.epp', {
        'port'     => $tor::daemon::socks::port,
        'policies' => $tor::daemon::socks::policies,
      }),
      order   => '02',
      target  => $tor::config_file,
    }
  }
}
