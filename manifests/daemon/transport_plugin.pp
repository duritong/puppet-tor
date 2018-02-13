# transport plugin
define tor::daemon::transport_plugin(
  $servertransport_plugin     = '',
  $servertransport_listenaddr = '',
  $servertransport_options    = '',
  $ext_port                   = '' ) {

  concat::fragment { '11.transport_plugin':
    content => template('tor/torrc.transport_plugin.erb'),
    order   => 11,
    target  => $tor::daemon::config_file,
  }
}
