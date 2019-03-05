class tor::install {

  package { 'tor':
    ensure => $tor::version,

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
