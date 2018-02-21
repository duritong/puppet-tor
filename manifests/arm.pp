# manage tor-arm
class tor::arm (
  $version = 'installed'
){
  include ::tor
  package{'tor-arm':
    ensure => $version,
  }
}
