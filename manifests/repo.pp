class tor::repo (
  $ensure      = present,
  $source_name = 'torproject.org',
  $include_src = false,
) {
  apt::source { $source_name:
    ensure      => $ensure,
    location    => 'https://deb.torproject.org/torproject.org/',
    key         => '886DDD89',
    include_src => $include_src,
  }
}
