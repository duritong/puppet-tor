class tor (
  $ensure_version = 'installed',
  $use_munin      = false,
){

  package { [ 'tor', 'tor-geoipdb' ]:
    ensure => $ensure_version,
  }

  service { 'tor':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['tor'],
  }

  if $use_munin {
    include tor::munin
  }
}
