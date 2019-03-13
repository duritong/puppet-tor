# exit policies
define tor::daemon::exit_policy(
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Array[String]] $accept   = undef,
  Optional[Array[String]] $reject   = undef,
  Boolean $reject_private           = true,
) {
  if $ensure == 'present' {
    concat::fragment { "07.exit_policy.${name}":
      content => epp('tor/torrc/07_exit_policy.epp', {
        'name'           => $name,
        'accept'         => $tor::daemon::exit_policy::accept,
        'reject'         => $tor::daemon::exit_policy::reject,
        'reject_private' => $tor::daemon::exit_policy::reject_private,
      }),
      order   => '07',
      target  => $tor::config_file,
    }
  }
}

