# manages an onionbalance installation
#
# Parameters:
#
#  services: a hash of onionbalance service instances
#    services => {
#      keyname_of_service1 => {
#        name1        => onionservice_addr_3,
#        name2        => onionservice_addr_2,
#        _key_content => content_of_key_of_onionbalanced_service1,
#      },
#    }
#
class tor::onionbalance(
  $services,
) {

  include ::tor

  case $facts['osfamily'] {
    'Debian': {
      $pkg_name = 'onionbalance'
      $instance_file = '/etc/tor/instances/onionbalance/torrc'
      $instance_user = '_tor-onionbalance'
      exec{'/usr/sbin/tor-instance-create onionbalance':
        creates => '/etc/tor/instances/onionbalance',
        require => Package['tor'],
        before  => File[$instance_file],
      } -> augeas{"manage_onionbalance_in_group_${instance_user}":
        context => '/files/etc/group',
        changes => [ "set ${instance_user}/user[last()+1] onionbalance" ],
        onlyif  => "match ${instance_user}/*[../user='onionbalance'] size == 0",
        require => Package['onionbalance'],
      }
    }
    'RedHat': {
      $instance_file = '/etc/tor/onionbalance.torrc'
      $instance_user = 'toranon'
      $pkg_name      = 'python2-onionbalance'
    }
    default: {
      fail("OSFamily ${facts['osfamily']} not (yet) supported for onionbalance")
    }
  }

  package{$pkg_name:
    ensure => 'installed',
    tag    => 'onionbalance',
  } -> file{
    '/etc/onionbalance/config.yaml':
      content => template('tor/onionbalance/config.yaml.erb'),
      owner   => root,
      group   => $instance_user,
      mode    => '0640',
      notify  => Service['onionbalance'];
    $instance_file:
      content => template("tor/onionbalance/${facts['osfamily']}.torrc.erb"),
      owner   => root,
      group   => 0,
      mode    => '0644',
      require => Package['tor'],
      notify  => Service['tor@onionbalance'],
  }

  $keys = keys($services)
  tor::onionbalance::keys{
    $keys:
      values => $services,
      group  => $instance_user,
  }

  service{
    'tor@onionbalance':
      ensure => running,
      enable => true;
    'onionbalance':
      ensure    => running,
      enable    => true,
      subscribe => Service['tor@onionbalance'];
  }

}
