# AutomapHostsOnResolve definition
define tor::daemon::automap_hosts_on_resolve(
  Enum['present','absent'] $ensure  = 'present',
  Boolean $automap_hosts_on_resolve = false,
){
  if $ensure == 'present' {
    concat::fragment { "13.automaphostsonresolve.${name}":
      content => epp('tor/torrc/13_automaphostsonresolve.epp', {
        'automap_hosts_on_resolve' => $automap_hosts_on_resolve,
      }),
      order   => '13',
      target  => $tor::config_file,
    }
  }
}
