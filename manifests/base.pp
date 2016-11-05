# basic management of resources for tor
class tor::base {
  package {'tor':
    ensure => $tor::version,
  }
  case $osfamily {
    'Debian': {
      package {'tor-geoipdb':
        ensure => $tor::version,
        before => Service['tor'],
      }
    }
  }

  service { 'tor':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['tor'],
  }
}
