# map address definition
define tor::daemon::map_address(
  $ensure     = 'present',
  $address    = '',
  $newaddress = '',
) {
  if $ensure == 'present' {
    concat::fragment { "09.map_address.${name}":
      content => template('tor/torrc/09_map_address.erb'),
      order   => '09',
      target  => $tor::daemon::config_file,
    }
  }
}

