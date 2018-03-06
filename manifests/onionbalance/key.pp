# manage onionbalance keys
#
#  key_content will be treated as path
#  to a file containing the key content
#  if the value starts with a /
#
define tor::onionbalance::key(
  $key_content,
  $group,
){

  if $key_content =~ /^\// {
    $content = file($key_content)
  } else {
    $content = $key_content
  }
  Package<| tag == 'onionbalance' |> -> file{
    "/etc/onionbalance/${name}.key":
      content => $content,
      owner   => root,
      group   => $group,
      mode    => '0640',
      notify  => Service['onionbalance'];
  }
}
