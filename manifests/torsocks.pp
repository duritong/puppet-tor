# manage torsocks
class tor::torsocks (
  $ensure_version = 'installed'
){
  include ::tor::daemon
  package{'torsocks':
    ensure => $ensure_version,
  }
}
