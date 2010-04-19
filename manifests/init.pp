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
    source  => "puppet://$server/modules/polipo/files/polipo.conf",
    notify  => Service["polipo"],
  }
}
