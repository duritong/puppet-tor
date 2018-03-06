# a wrapper to manage onionbalance keys
define tor::onionbalance::keys(
  $values,
  $group,
) {
  tor::onionbalance::key{
    $name:
      key_content => $values[$name]['_key_content'],
      group       => $group,
  }
}
