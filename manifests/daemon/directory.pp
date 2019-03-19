# directory advertising
define tor::daemon::directory (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Tor::Port] $port         = undef,
  String $port_front_page           = '/etc/tor/tor-exit-notice.html',
) {
  if $ensure == 'present' {
    concat::fragment { '06.directory':
      content => epp('tor/torrc/06_directory.epp', {
        'port'            => $tor::daemon::directory::port,
        'port_front_page' => $tor::daemon::directory::port_front_page,
      }),
      order   => '06',
      target  => $tor::config_file,
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
