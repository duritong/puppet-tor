class tor::torsocks {
  if !$torsocks_ensure_version { $torsocks_ensure_version = 'installed' }
  include ::tor
  package{'torsocks':
    ensure => $torsocks_ensure_version,
  }
}
