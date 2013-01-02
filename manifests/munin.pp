# munin plugins for puppet
class tor::munin {
  Munin::Plugin::Deploy {
    config  => "user debian-tor\n env.cookiefile /var/run/tor/control.authcookie"
  }
  munin::plugin::deploy {
    'tor_connections':
      source => 'tor/munin/tor_connections';
    'tor_routers':
      source => 'tor/munin/tor_routers';
    'tor_traffic':
      source => 'tor/munin/tor_traffic';
  }
}
