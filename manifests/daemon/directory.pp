# @summary Extend basic Tor configuration with a snippet based configuration.
#          Directory module.
#
# @example Advertise your Tor directory service on port 80.
#   tor::daemon::directory { 'ssh_directory':
#     port            => '80',
#     port_front_page => '/etc/tor/tor.html';
#   }
#
# @param ensure
#   Whether this module should be used or not.
#
# @param port
#   Advertise the directory service on this port.
#
# @param port_front_page
#   Path to the HTML front page for the directory service.
#
define tor::daemon::directory (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Tor::Port] $port         = undef,
  String $port_front_page           = '/etc/tor/tor-exit-notice.html',
) {
  if $ensure == 'present' {
    concat::fragment { '06.directory':
      content => epp('tor/torrc/06_directory.epp', {
        'port'            => $port,
        'port_front_page' => $port_front_page,
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
