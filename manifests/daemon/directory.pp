# directory advertising
define tor::daemon::directory (
  $port             = 0,
  $port_front_page  = '/etc/tor/tor-exit-notice.html',
  $ensure           = present ) {

  concat::fragment { '06.directory':
    content => template('tor/torrc.directory.erb'),
    order   => 06,
    target  => $tor::daemon::config_file,
  }

  file { '/etc/tor/tor-exit-notice.html':
    ensure  => $ensure,
    source  => 'puppet:///modules/tor/tor-exit-notice.html',
    require => File['/etc/tor'],
    owner   => 'debian-tor',
    group   => 'debian-tor',
    mode    => '0644',
  }
}

