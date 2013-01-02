# manage a basic tor installation
class tor (
  $ensure_version = 'installed',
  $use_munin      = false
){

  include tor::base

  if $use_munin {
    include tor::munin
  }
}
