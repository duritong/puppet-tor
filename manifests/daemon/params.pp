# setup variables for different distributions
class tor::daemon::params {

  case $osfamily {
    'RedHat': {
      $user        = 'toranon'
      $group       = 'toranon'
      $manage_user = false
    }
    'Debian': {
      $user        = 'debian-tor'
      $group       = 'debian-tor'
      $manage_user = true
    }
    default: { fail("No support for osfamily ${osfamily}") }
  }

}
