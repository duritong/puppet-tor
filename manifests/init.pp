class tor (
  Boolean $arm                      = false,
  Boolean $automap_hosts_on_resolve = false,
  String  $data_dir                 = '/var/lib/tor',
  String  $config_file              = '/etc/tor/torrc',
  Array   $log_rules                = [ 'notice file /var/log/tor/notices.log' ],
  Boolean $safe_logging             = true,
  Boolean $torsocks                 = false,
  String  $version                  = 'installed',
  Boolean $use_bridges              = false,
) {

  include ::tor::install
  include ::tor::daemon::base

  service { 'tor':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['tor'],
  }
}
