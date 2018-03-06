# manage a complete tor
# installation with all the basics
class tor::compact {
  include ::tor
  include tor::torsocks
  if $facts['osfamily'] == 'Debian' {
    include tor::polipo
  }
}
