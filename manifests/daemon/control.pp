# control definition
define tor::daemon::control(
  Enum['present', 'absent'] $ensure            = 'present',
  Variant[0, Stdlib::Port] $port               = 0,
  Boolean $cookie_authentication               = false,
  Optional[Stdlib::Unixpath] $cookie_auth_file = undef,
  Boolean $cookie_auth_file_group_readable     = false,
  Optional[String] $hashed_control_password    = undef,
) {

  if $ensure == 'present' {
    unless $cookie_authentication and $hashed_control_password {
      fail('You need to define the tor control password')
    }

    if !$cookie_authentication and ($cookie_auth_file or $cookie_auth_file_group_readable) { # lint:ignore:80chars 
      notice('You set a tor cookie authentication option, but do not have cookie_authentication on') # lint:ignore:80chars
    }

    concat::fragment { '04.control':
      content => epp('tor/torrc/04_control.epp', {
        'port'                           => $tor:daemon::control::port,
        'cookie_authentication'          => $tor:daemon::control::cookie_authentication,
        'cookie_auth_file'               => $tor:daemon::control::cookie_auth_file,
        'cookie_auth_file_group_redable' => $tor:daemon::control::cookie_auth_file_group_redable,
        'hashed_control_password'        => $tor:daemon::control::hashed_control_password,
      }),
      order   => '04',
      target  => $tor::daemon::config_file,
    }
  }
}
