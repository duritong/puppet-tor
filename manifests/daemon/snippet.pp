# Arbitrary torrc snippet definition
define tor::daemon::snippet(
  $content = '' ) {

  concat::fragment { "99.snippet.${name}":
    content => $content,
    order   => 99,
    target  => $tor::daemon::config_file,
  }
}

