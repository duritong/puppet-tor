# hidden services definition
define tor::daemon::hidden_service(
  $ports      = [],
  $single_hop = false,
  $data_dir   = $tor::daemon::data_dir,
  $ensure     = present ) {

  concat::fragment { "05.hidden_service.${name}":
    ensure  => $ensure,
    content => template('tor/torrc.hidden_service.erb'),
    order   => 05,
    target  => $tor::daemon::config_file,
  }
}

