# control definition
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
        'port'                           => $port,
        'cookie_authentication'          => $cookie_authentication,
        'cookie_auth_file'               => $cookie_auth_file,
        'cookie_auth_file_group_redable' => $cookie_auth_file_group_readable,
        'hashed_control_password'        => $hashed_control_password,
      }),
      order   => '04',
      target  => $tor::config_file,
    }
  }
}
