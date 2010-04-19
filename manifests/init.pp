class tor {
  package { [ "tor", "polipo" ]:
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

  file { "/etc/polipo/config":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet://$server/modules/tor/polipo.conf",
    notify  => Service["polipo"],
  }
}
