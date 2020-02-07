# @summary Manages package installation.
#
class tor::install {

  if $tor::use_upstream_repository and $::osfamily == 'Debian' {
    ensure_packages('apt-transport-https')

    apt::source {
      'torproject':
        comment  => 'TorProject',
        location => '[signed-by=/usr/share/keyrings/torproject.gpg] https://deb.torproject.org/torproject.org',
        repos    => 'main',
        release  => $tor::upstream_release,
        require  => [ Package['apt-transport-https'] ];
    }

    apt::pin {
      'torproject':
        packages   => [ 'tor', 'tor-geoipdb' ],
        priority   => 1000,
        originator => 'TorProject',
        component  => 'main',
    }

    file {
      '/usr/share/keyrings/torproject.gpg':
        ensure => present,
        source => 'puppet:///modules/tor/torproject.gpg',
        owner  => 'root',
        group  => 0,
        mode   => '0644';
    }

    package { 'tor':
      ensure  => $tor::version,
      require => Apt::Source['torproject'];
    }
  }

  elsif $tor::use_upstream_repository and $::osfamily != 'Debian' {
    fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports upstream repository for osfamily Debian") # lint:ignore:80chars
  }

  else {
    package { 'tor':
      ensure => $tor::version,
    }
  }

  if $tor::arm {
    package { 'tor-arm':
      ensure => $tor::arm_version,
    }
  }

  if $tor::torsocks {
    package{ 'torsocks':
      ensure => $tor::torsocks_version,
    }
  }
}
