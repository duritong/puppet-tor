# @summary Extend basic Tor configuration with a snippet based configuration.
#          Onion Service module.
#
# @example Make SSH available as a Tor service
#   tor::daemon::onion_service { 'onion-ssh':
#     ports => [ '22' ],
#     v3    => true,
#   }
#
# @example Make SSH available as a Tor service, using an existing key
#   tor::daemon::onion_service { 'onion-ssh':
#     ports   => [ '22' ],
#     v3      => true,
#     v3_data => {
#      'hs_ed25519_secret_key' => 'your onion v3 private key',
#      'hs_ed25519_public_key' => 'your onion v3 public key',
#      'hostname'              => 'vww7ybal4bd8szmgncyruucpgfkqahzddi38ktceo3ah8ngmcopnpyyd.onion',
#     }
#   }
#
# @param ensure
#   Whether this module should be used or not.
#
# @param ports
#   The onion service ports.
#
# @param data_dir
#   The hidden service data directory.
#
# @param v3
#   Whether the onion service should be a v3 hidden service.
#
# @param single_hop
#   Whether the onion service should be single-hop.
#
# @param private_key
#   The onion address private key for the hidden service. Either specify this or
#   $private_key_name and $private_key_store_path
#
# @param v3_data
#   Use this parameter to specify an existing key pair and hostname for a
#   v3 Hidden Service. Leave it undefined if you want puppet to generate them
#   for you.
#
# @option v3_data [String] :hs_ed25519_secret_key
#   ed25519 private key for the v3 Hidden Service.
#
# @option v3_data [String] :hs_ed25519_public_key
#   ed25519 public key for the v3 Hidden Service.
#
# @option v3_data [String] :hostname
#   Full onion hostname for the Hidden Service.
#
# @param v2_warn
#   Enable the Onionv2 deprecation warning.
#
# @param private_key_name
#   The name of the onion address private key file for the hidden service.
#
# @param private_key_store_path
#   The path to directory where the onion address private key file is stored.
#
define tor::daemon::onion_service(
  Enum['present', 'absent'] $ensure           = 'present',
  Array[String] $ports                        = [],
  Stdlib::Unixpath $data_dir                  = $tor::data_dir,
  Boolean $v3                                 = true,
  Boolean $single_hop                         = false,
  Optional[Sensitive[String[1]]] $private_key = undef,
  Optional[Struct[{
    'hs_ed25519_secret_key' => Sensitive[String[1]],
    'hs_ed25519_public_key' => String[1],
    'hostname' => String[1],
  }]] $v3_data                                = undef,
  String $private_key_name                    = $name,
  Optional[String] $private_key_store_path    = undef,
  Boolean $v2_warn                            = true,
) {

  $data_dir_path = "${data_dir}/${name}"
  if $ensure == 'present' {
    concat::fragment { "05.onion_service.${name}":
      content => epp('tor/torrc/05_onion_service.epp', {
        'single_hop'    => $single_hop,
        'name'          => $name,
        'data_dir_path' => $data_dir_path,
        'ports'         => $ports,
        'v3'            => $v3,
      }),
      order   => '05',
      target  => $tor::config_file,
    }
    if $single_hop {
      file { "${data_dir_path}/onion_service_non_anonymous":
        ensure => file,
        notify => Service['tor'];
      }
    }
  }
  if ($private_key or $v3_data) or ($private_key_name and $private_key_store_path) {
    file{
      $data_dir_path:
        purge   => true,
        force   => true,
        recurse => true;
    }
    if $ensure == 'present' {
      include tor::daemon::params
      File[$data_dir_path]{
        ensure  => directory,
        owner   => $tor::daemon::params::user,
        group   => $tor::daemon::params::group,
        mode    => '0600',
        require => Package['tor'],
      }
      if $v3 {
        if $v3_data {
          $real_v3_data = $v3_data
        } else {
          $real_v3_data = tor::onionv3_key($private_key_store_path,$private_key_name)
        }
        file{
          default:
            owner  => $tor::daemon::params::user,
            group  => $tor::daemon::params::group,
            mode   => '0600',
            notify => Service['tor'];
          "${data_dir_path}/authorized_clients":
            ensure => directory;
          "${data_dir_path}/hs_ed25519_secret_key":
            content => $real_v3_data['hs_ed25519_secret_key'];
          "${data_dir_path}/hs_ed25519_public_key":
            content => $real_v3_data['hs_ed25519_public_key'];
          "${data_dir_path}/hostname":
            content => "${real_v3_data['hostname']}\n";
        }
      } else {
        unless $v2_warn {
          notify {
            '[tor] *** DEPRECATION WARNING***: onionV2 will soon be deprecated in Tor and in this module. You should upgrade to onionV3 as soon as possible.':
          }
        }
        if $private_key {
          $os_hostname = tor::onion_address($private_key.unwrap)
          $real_private_key = $private_key
        } else {
          $tmp = tor::generate_onion_key($private_key_store_path,$private_key_name)
          $os_hostname = $tmp[0]
          $real_private_key = $tmp[1]
        }
        file{
          default:
            owner  => $tor::daemon::params::user,
            group  => $tor::daemon::params::group,
            mode   => '0600',
            notify => Service['tor'];
          "${data_dir_path}/private_key":
            content => $real_private_key;
          "${data_dir_path}/hostname":
            content => "${os_hostname}.onion\n";
        }
      }
    } else {
      File[$data_dir_path]{
        ensure => absent
      }
    }
  }
}

