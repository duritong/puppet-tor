class tor {
  package { [ "tor", "polipo", "torsocks" ]:
    ensure => installed,
  }

  service { "tor":
    ensure  => running,
    require => [ Package['tor'], Service["polipo"] ],
  }

  service { "polipo":
    ensure  => running,
    require => Package["polipo"],
  }

  file { "/etc/polipo":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  file { "/etc/polipo/config":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/tor/polipo.conf",
    notify  => Service["polipo"],
    require => File["/etc/polipo"],
  }

  # TODO: restore file to original state after the following bug is solved:
  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=580434
  file { "/etc/cron.daily/polipo":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    source  => "puppet:///modules/tor/polipo.cron",
  }
}
