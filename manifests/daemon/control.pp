# @summary Extend basic Tor configuration with a snippet based configuration.
#          Tor Control module.
#
# @example Use port 80 as the Tor Control port and authenticate to it using
#          a hashed password.
#   tor::daemon::control { 'foo-control':
#     port                    => 80,
#     hashed_control_password => '<somehash>',
#     ensure                  => present;
#   }
#
# @param ensure
#   Whether this module should be used or not.
#
# @param port
#   The Tor Control port to manage your Tor instance remotely.
#
# @param cookie_authentication
#   Whether Cookie Authentication to the Tor Control port should be allowed.
#
# @param cookie_auth_file
#   Path to the Cookie Authentication file for the Tor Control port.
#
# @param cookie_auth_file_group_readable
#   Whether to allow the unix group running the tor process to read the cookie
#   file.
#
# @param hashed_control_password
#   Hashed password to authenticate to the Tor Control port.
#
define tor::daemon::control(
  Enum['present', 'absent'] $ensure            = 'present',
  Optional[Stdlib::Port] $port                 = undef,
  Boolean $cookie_authentication               = false,
  Optional[Stdlib::Unixpath] $cookie_auth_file = undef,
  Boolean $cookie_auth_file_group_readable     = false,
  Optional[String] $hashed_control_password    = undef,
) {

  if $ensure == 'present' {
    if $cookie_authentication == false and $hashed_control_password == undef {
      fail('You need to define the tor control password')
    }

    if !$cookie_authentication and ($cookie_auth_file or $cookie_auth_file_group_readable) { # lint:ignore:80chars
      notice('You set a tor cookie authentication option, but do not have cookie_authentication on') # lint:ignore:80chars
    }

    concat::fragment { '04.control':
      content => epp('tor/torrc/04_control.epp', {
        'port'                            => $port,
        'cookie_authentication'           => $cookie_authentication,
        'cookie_auth_file'                => $cookie_auth_file,
        'cookie_auth_file_group_readable' => $cookie_auth_file_group_readable,
        'hashed_control_password'         => $hashed_control_password,
      }),
      order   => '04',
      target  => $tor::config_file,
    }
  }
}
