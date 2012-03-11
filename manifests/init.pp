import "polipo.pp"
import "daemon.pp"

class tor {

  if !$tor_ensure_version { $tor_ensure_version = 'installed' }

  package { [ "tor", "torsocks" ]:
    ensure => $tor_ensure_version,
  }

  service { 'tor':
    ensure  => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => Package['tor'],
  }

  if $use_munin {
    include tor::munin
  }
}
