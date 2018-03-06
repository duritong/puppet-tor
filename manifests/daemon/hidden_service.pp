# hidden services definition
define tor::daemon::hidden_service(
  $ports         = [],
  $single_hop    = false,
  $v3            = false,
  $data_dir      = $tor::daemon::data_dir,
) {
  info("Using tor::daemon::hidden_service is deprecated, please use tor::daemon::onion_service for ${name}")
  tor::daemon::onion_service{
    $name:
      ports      => $ports,
      single_hop => $single_hop,
      v3         => $v3,
      data_dir   => $data_dir,
  }
}
