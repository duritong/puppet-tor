# hidden services definition
define tor::daemon::hidden_service(
  Array[Stdlib::Port] $ports = [],
  Boolean $single_hop        = false,
  Boolean $v3                = false,
  Stdlib::Unixpath $data_dir = $tor::data_dir,
) {
  info("Using tor::daemon::hidden_service is deprecated, please use tor::daemon::onion_service for ${name}")
  tor::daemon::onion_service {
    $name:
      ports      => $tor::daemon::hidden_service::ports,
      single_hop => $tor::daemon::hidden_service::single_hop,
      v3         => $tor::daemon::hidden_service::v3,
      data_dir   => $tor::daemon::hidden_service::data_dir,
  }
}
