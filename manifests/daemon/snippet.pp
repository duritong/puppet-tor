# @summary Extend basic Tor configuration with a snippet based configuration.
#          Arbitrary snippet module.
#
# @param ensure
#   Whether this module should be used or not.
#
# @param content
#   Arbitrary string to include in Tor's configuration file.
#
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
