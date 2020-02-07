# @summary Extend basic Tor configuration with a snippet based configuration.
#          Exit policy module.
#
# @example Reject everything but traffic on port 22 to 192.168.0.1.
#   tor::daemon::exit_policy { 'ssh_exit_policy':
#     accept => [ '192.168.0.1:22' ],
#     reject => [ '*:*' ];
#   }
#
# @param ensure
#   Whether this module should be used or not.
#
# @param accept
#   Array of IPs and ports to be accepted in the exit policy.
#
# @param reject
#   Array of IPs and ports to be rejected in the exit policy.
#
# @param reject_private
#   Whether to reject all private local networks in the exit policy.
#
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
        'accept'         => $accept,
        'reject'         => $reject,
        'reject_private' => $reject_private,
      }),
      order   => '07',
      target  => $tor::config_file,
    }
  }
}

