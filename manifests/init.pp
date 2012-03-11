import "polipo.pp"
import "daemon.pp"

class tor {
  package { [ "tor", "torsocks" ]:
    ensure => installed,
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
