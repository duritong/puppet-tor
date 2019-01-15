# transport plugin
define tor::daemon::transport_plugin(
  $ensure                     = 'present',
  $servertransport_plugin     = '',
  $servertransport_listenaddr = '',
  $servertransport_options    = '',
  $ext_port                   = '',
) {
  if $ensure == 'present' {
    concat::fragment { '12.transport_plugin':
      content => template('tor/torrc/12_transport_plugin.erb'),
      order   => 12,
      target  => $tor::daemon::config_file,
    }
  }
}
