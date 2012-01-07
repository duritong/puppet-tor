import "polipo.pp"
import "daemon.pp"
import "relay.pp"
import "bridge.pp"

class tor {
  package { "privoxy":
    ensure => absent,
  }

  package { [ "tor", "polipo", "torsocks" ]:
    ensure => installed,
  }
}
