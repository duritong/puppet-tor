class tor::install {

  package { 'tor':
    ensure => $tor::version,

    if $facts['osfamily'] == 'Debian' {
      'tor-geoipdb':
        ensure => $tor::version,
        before => Service['tor'],
    }

    if $tor::arm {
      'tor-arm':
        ensure => $tor::version,
    }

    if $tor::torsocks {
      'torsocks':
        ensure => $tor::version,
    }
  }
}
