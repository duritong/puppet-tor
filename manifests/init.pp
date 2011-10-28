class tor {
  package {'tor':
    ensure => installed,
  }

  service { "tor":
    ensure  => running,
    enable  => true,
    require => Package['tor'],
  }
}
