class tor (
  Boolean $arm      = false,
  Boolean $torsocks = false,
  String  $version  = 'installed',
) {

  include ::tor::install

  service { 'tor':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['tor'],
  }
}
