# manage torsocks
class tor::torsocks (
  $version = 'installed'
){
  include ::tor::daemon
  package{'torsocks':
    ensure => $version,
  }
}
