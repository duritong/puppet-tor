# map address definition
define tor::daemon::map_address(
  $address    = '',
  $newaddress = '' ) {

  concat::fragment { "08.map_address.${name}":
    content => template('tor/torrc.map_address.erb'),
    order   => '08',
    target  => $tor::daemon::config_file,
  }
}

