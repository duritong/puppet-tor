import "polipo.pp"
import "daemon.pp"
import "relay.pp"
import "bridge.pp"

class tor {
  package { [ "tor", "torsocks" ]:
    ensure => installed,
  }

  service { "tor": {
    ensure  => running,
    require => Package['tor'],
  }
}
