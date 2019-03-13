class tor::install {

  if $tor::use_upstream_repository and $::osfamily == 'Debian' {
    package { 'apt-transport-https':
      ensure => 'present';
    }

    apt::key { 'torproject':
      id     => 'A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89',
      source => 'https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc';
    }

    apt::source { 'torproject':
      comment  => 'TorProject',
      pin      => 999,
      location => 'https://deb.torproject.org/torproject.org/',
      repos    => 'main',
      release  => $tor::upstream_release,
      require  => [ Apt::Key['torproject'], Package['apt-transport-https'] ];
    }

    package { 'tor':
      ensure  => $tor::version,
      require => Apt::Source['torproject'];
    }
  }

  elsif $tor::use_upstream_repository and $::osfamily != 'Debian' {
    fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports upstream repository for osfamily Debian and Ubuntu") # lint:ignore:80chars
  }

  else {
    package { 'tor':
      ensure => $tor::version,
    }
  }

  if $tor::arm {
    package { 'tor-arm':
      ensure => $tor::version,
    }
  }

  if $tor::torsocks {
    package{ 'torsocks':
      ensure => $tor::version,
    }
  }
}
