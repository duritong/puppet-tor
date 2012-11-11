class tor::polipo::debian inherits tor::polipo::base {
  # TODO: restore file to original state after the following bug is solved:
  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=580434
  file { '/etc/cron.daily/polipo':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => Package['polipo'],
    source  => 'puppet:///modules/tor/polipo/polipo.cron',
  }
}
