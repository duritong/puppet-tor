# directory advertising
define tor::daemon::directory (
  Enum['present', 'absent'] $ensure = 'present',
  Stdlib::Port $port                = 0,
  String $port_front_page           = '/etc/tor/tor-exit-notice.html',
) {
  if $ensure == 'present' {
    concat::fragment { '06.directory':
      content => template('tor/torrc/06_directory.erb'),
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
