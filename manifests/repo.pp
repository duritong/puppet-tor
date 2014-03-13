class tor::repo (
  $ensure      = present,
  $name        = 'torproject.org',
  $include_src = false,
) {
  apt::source { $name:
    ensure      => $ensure,
    location    => 'https://deb.torproject.org/torproject.org/',
    key         => '886DDD89',
    include_src => $include_src,
  }
}
