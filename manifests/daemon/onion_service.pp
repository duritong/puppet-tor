# onion services definition
define tor::daemon::onion_service(
  Enum['present', 'absent'] $ensure        = 'present',
  Array[Stdlib::Port] $ports               = [],
  String $data_dir                         = $tor::daemon::data_dir,
  Boolean $v3                              = false,
  Boolean $single_hop                      = false,
  Optional[String] $private_key            = undef,
  String $private_key_name                 = $name,
  Optional[String] $private_key_store_path = undef,
) {

  $data_dir_path = "${data_dir}/${name}"
  if $ensure == 'present' {
    include ::tor::daemon::params
    concat::fragment { "05.onion_service.${name}":
      content => template('tor/torrc/05_onion_service.erb'),
      order   => '05',
      target  => $tor::daemon::config_file,
    }
    if $single_hop {
      file { "${$data_dir_path}/onion_service_non_anonymous":
        ensure => 'present',
        notify => Service['tor'];
      }
    }
  }
  if $private_key or ($private_key_name and $private_key_store_path) {
    if $private_key and ($private_key_name and $private_key_store_path) {
      fail('Either private_key OR (private_key_name AND private_key_store_path) must be set, but not all three of them')
    }
    if $private_key_store_path and $private_key_name {
      $tmp = generate_onion_key($private_key_store_path,$private_key_name)
      $os_hostname = $tmp[0]
      $real_private_key = $tmp[1]
    } else {
      $os_hostname = onion_address($private_key)
      $real_private_key = $private_key
    }
    file{
      $data_dir_path:
        ensure  => directory,
        purge   => true,
        force   => true,
        recurse => true,
        owner   => $tor::daemon::params::user,
        group   => $tor::daemon::params::group,
        mode    => '0600',
        require => Package['tor'];
      "${data_dir_path}/private_key":
        content => $real_private_key,
        owner   => $tor::daemon::params::user,
        group   => $tor::daemon::params::group,
        mode    => '0600',
        notify  => Service['tor'];
      "${data_dir_path}/hostname":
        content => "${os_hostname}.onion\n",
        owner   => $tor::daemon::params::user,
        group   => $tor::daemon::params::group,
        mode    => '0600',
        notify  => Service['tor'];
    }
  }
}

