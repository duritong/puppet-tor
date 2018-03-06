# Arbitrary torrc snippet definition
define tor::daemon::snippet(
  $ensure  = 'present',
  $content = '',
) {

  if $ensure == 'present' {
    concat::fragment { "99.snippet.${name}":
      content => $content,
      order   => '99',
      target  => $tor::daemon::config_file,
    }
  }
}

