class tor::munin {

  file {
    "/usr/local/share/munin-plugins/tor_connections":
      source => "puppet:///modules/tor/munin/tor_connections",
      mode => 0755, owner => root, group => root;
    
    "/usr/local/share/munin-plugins/tor_routers":
      source => "puppet:///modules/tor/munin/tor_routers",
      mode => 0755, owner => root, group => root;

    "/usr/local/share/munin-plugins/tor_traffic":
      source => "puppet:///modules/tor/munin/tor_traffic",
      mode => 0755, owner => root, group => root;
  }

  munin::plugin {
    [ "tor_connections", "tor_routers", "tor_traffic" ]:
      ensure => present,
      config => "user debian-tor\n env.cookiefile /var/lib/tor/control_auth_cookie",
      script_path_in => "/usr/local/share/munin-plugins";
  }
}
