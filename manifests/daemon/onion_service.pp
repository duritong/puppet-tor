# onion services definition
define tor::daemon::onion_service(
  $ensure                 = 'present',
  $ports                  = [],
  $data_dir               = $tor::daemon::data_dir,
  $v3                     = false,
  $single_hop             = false,
  $private_key            = undef,
  $private_key_name       = $name,
  $private_key_store_path = undef,
) {

  $data_dir_path = "${data_dir}/${name}"
  if $ensure == 'present' {
    include ::tor::daemon::params
    concat::fragment { "05.onion_service.${name}":
      content => template('tor/torrc.onion_service.erb'),
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

