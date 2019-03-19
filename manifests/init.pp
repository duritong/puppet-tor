class tor (
  Boolean $arm                      = false,
  Boolean $automap_hosts_on_resolve = false,
  Stdlib::Unixpath $data_dir        = '/var/lib/tor',
  String  $config_file              = '/etc/tor/torrc',
  Array   $log_rules                = [ 'notice file /var/log/tor/notices.log' ],
  Boolean $safe_logging             = true,
  Boolean $torsocks                 = false,
  String  $version                  = 'installed',
  Boolean $use_bridges              = false,
  Boolean $use_upstream_repository  = false,
  String  $upstream_release         = 'stable',
) {

  include ::tor::install
  include ::tor::daemon::base

  service { 'tor':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    provider   => 'systemd',
    require    => Package['tor'],
  }
}
