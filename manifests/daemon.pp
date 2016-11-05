# manage a snippet based tor installation
class tor::daemon (
  $use_munin                = false,
  $data_dir                 = '/var/lib/tor',
  $config_file              = '/etc/tor/torrc',
  $use_bridges              = 0,
  $automap_hosts_on_resolve = 0,
  $log_rules                = [ 'notice file /var/log/tor/notices.log' ],
  $safe_logging             = 1,
) {

  include ::tor
  include ::tor::daemon::base

  if $use_munin {
    include ::tor::munin
  }
}
