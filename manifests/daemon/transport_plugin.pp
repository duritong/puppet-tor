# transport plugin
define tor::daemon::transport_plugin(
  Enum['present', 'absent'] $ensure            = 'present',
  Optional[String] $servertransport_plugin     = undef,
  Optional[String] $servertransport_listenaddr = undef,
  Optional[String] $servertransport_options    = undef,
  Optional[Stdlib::Port] $ext_port             = undef,
) {
  if $ensure == 'present' {
    concat::fragment { '12.transport_plugin':
      content => epp('tor/torrc/12_transport_plugin.epp', {
        'servertransport_plugin'     => $tor::daemon::transport_plugin::servertransport_plugin,
        'servertransport_listenaddr' => $tor::daemon::transport_plugin::servertransport_listenaddr,
        'servertransport_options'    => $tor::daemon::transport_plugin::servertransport_options,
        'ext_port'                   => $tor::daemon::transport_plugin::ext_port,
      }),
      order   => 12,
      target  => $tor::config_file,
    }
  }
}
