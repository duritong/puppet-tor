# @summary Manages package installation.
#
class tor::install {

  if $tor::use_upstream_repository and $facts['os']['family'] == 'Debian' {
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
        component  => 'main';

      'torproject-negative':
        packages   => '*',
        priority   => 200,
        originator => 'TorProject',
        component  => 'main';
    }

    file {
      '/usr/share/keyrings/torproject.gpg':
        ensure => file,
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

  elsif $tor::use_upstream_repository and $facts['os']['family'] != 'Debian' {
    fail("Unsupported managed repository for osfamily: ${facts['os']['family']}, operatingsystem: ${facts['os']['name']}, module ${module_name} currently only supports upstream repository for osfamily Debian") # lint:ignore:80chars
  }

  else {
    package { 'tor':
      ensure => $tor::version,
    }
  }

  if $tor::arm {
    package {
      'nyx':
        ensure => $tor::arm_version;

      'tor-arm':
        ensure => purged;
    }
    notify {
      '[tor] *** DEPRECATION WARNING***: the "tor::arm" variable has been renamed "tor::nyx". The old variable will eventually be removed.':
    }
    notify {
      '[tor] *** DEPRECATION WARNING***: the "tor::arm_version" variable has been renamed "tor::nyx_version". The old variable will eventually be removed.':
    }
  }
  elsif $tor::nyx {
    package {
      'nyx':
        ensure => $tor::nyx_version;

      'tor-arm':
        ensure => purged;
    }
  }

  if $tor::torsocks {
    package{ 'torsocks':
      ensure => $tor::torsocks_version,
    }
  }
}
