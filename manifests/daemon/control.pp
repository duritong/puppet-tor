# control definition
define tor::daemon::control(
  $ensure                          = 'present',
  $port                            = 0,
  $hashed_control_password         = '',
  $cookie_authentication           = 0,
  $cookie_auth_file                = '',
  $cookie_auth_file_group_readable = '',
) {

  if $ensure == 'present' {
    if $cookie_authentication == '0' and $hashed_control_password == '' {
      fail('You need to define the tor control password')
    }

    if $cookie_authentication == 0 and ($cookie_auth_file != '' or $cookie_auth_file_group_readable != '') { # lint:ignore:80chars 
      notice('You set a tor cookie authentication option, but do not have cookie_authentication on') # lint:ignore:80chars
    }

    concat::fragment { '04.control':
      content => template('tor/torrc.control.erb'),
      order   => '04',
      target  => $tor::daemon::config_file,
    }
  }
}
