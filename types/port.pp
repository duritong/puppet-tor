type Tor::Port = Variant[
  Stdlib::Port,
  Pattern[/\Aauto\Z/],
  Pattern[/\A([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])){3}:[0-9]+\z/], # Stdlib::IP::Address::V4:Port
  Pattern[/\A\[[[:xdigit:]]{1,4}(:[[:xdigit:]]{1,4}){7}(\/(1([01][0-9]|2[0-8])|[1-9][0-9]|[0-9]))?\]:[0-9]+\z/] # [Stdlib::IP:Address::V6:Full]:Port
]
