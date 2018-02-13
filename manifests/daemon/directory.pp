# directory advertising
define tor::daemon::directory (
  $ensure           = 'present',
  $port             = 0,
  $port_front_page  = '/etc/tor/tor-exit-notice.html',
) {
  if $ensure == 'present' {
    concat::fragment { '06.directory':
      content => template('tor/torrc.directory.erb'),
      order   => '06',
      target  => $tor::daemon::config_file,
    }
  }

  include ::tor::daemon::params
  file { '/etc/tor/tor-exit-notice.html':
    ensure  => $ensure,
    source  => 'puppet:///modules/tor/tor-exit-notice.html',
    require => File['/etc/tor'],
    owner   => $tor::daemon::params::user,
    group   => $tor::daemon::params::group,
    mode    => '0644',
  }
}
