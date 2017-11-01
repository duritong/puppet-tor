# socks definition
define tor::daemon::socks(
  $port = 0,
  $policies = [] ) {

  concat::fragment { '02.socks':
    content => template('tor/torrc.socks.erb'),
    order   => 02,
    target  => $tor::daemon::config_file,
  }
}
