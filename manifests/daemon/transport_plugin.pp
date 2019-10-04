# @summary Extend basic Tor configuration with a snippet based configuration.
#          Transport plugin module.
#
# @example Create an obfs4 transport plugin
#   tor::daemon::transport_plugins { "obfs4":
#     ext_port               => '80',
#     servertransport_plugin => 'obfs4 exec /usr/bin/obfs4proxy',
#   }
#
# @param ensure
#   Whether this module should be used or not.
#
# @param servertransport_plugin
#   The pluggable transport plugin command definition.
#
# @param servertransport_listenaddr
#   The listening address of any pluggable transport proxy that tries to launch
#   the transport.
#
# @param servertransport_options
#   The k=v parameters to the pluggable transport proxy.
#
# @param ext_port
#   The extended ORPort connection for your pluggable transport.
#
define tor::daemon::transport_plugin(
  Enum['present', 'absent'] $ensure            = 'present',
  Optional[String] $servertransport_plugin     = undef,
  Optional[String] $servertransport_listenaddr = undef,
  Optional[String] $servertransport_options    = undef,
  Optional[Tor::Port] $ext_port                = undef,
) {
  if $ensure == 'present' {
    concat::fragment { '12.transport_plugin':
      content => epp('tor/torrc/12_transport_plugin.epp', {
        'servertransport_plugin'     => $servertransport_plugin,
        'servertransport_listenaddr' => $servertransport_listenaddr,
        'servertransport_options'    => $servertransport_options,
        'ext_port'                   => $ext_port,
      }),
      order   => 12,
      target  => $tor::config_file,
    }
  }
}
