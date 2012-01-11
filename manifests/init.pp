import "polipo.pp"
import "daemon.pp"

class tor {
  package { [ "tor", "torsocks" ]:
    ensure => installed,
  }
}
