# add upstream repositories of torproject
class tor::repo (
  $ensure      = present,
  $source_name = 'torproject.org',
  $include_src = false,
) {
  case $::osfamily {
    'Debian': {
      $key      = '886DDD89'
      $location = 'https://deb.torproject.org/torproject.org/'
      class { 'tor::repo::debian': }
    }
    'RedHat': {
      if $source_name == 'copr-latest' and (versioncmp($facts['os']['release']['major'],'6') > 0) {
        include ::tor::repo::centos_latest
      }
      # no need as EPEL is the relevant reference
    }
    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily Debian and Ubuntu") # lint:ignore:80chars
    }
  }
}
