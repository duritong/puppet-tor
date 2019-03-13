# Arbitrary torrc snippet definition
define tor::daemon::snippet (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $content         = undef,
) {

  if $ensure == 'present' {
    concat::fragment { "99.snippet.${name}":
      content => $content,
      order   => '99',
      target  => $tor::config_file,
    }
  }
}
