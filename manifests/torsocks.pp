class tor::torsocks {
  include ::tor
  package{'torsocks':
    ensure => present,
  }
}
