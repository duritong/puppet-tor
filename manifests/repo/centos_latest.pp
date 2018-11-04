# PRIVATE class
class tor::repo::centos_latest(
  $priority = 1,
) {
  # from: https://copr.fedorainfracloud.org/coprs/maha/tor-latest/repo/epel-7/maha-tor-latest-epel-7.repo
  yum::repo{
    'maha-tor-latest':
      descr         => 'Copr repo for tor-latest owned by maha',
      baseurl       => 'https://copr-be.cloud.fedoraproject.org/results/maha/tor-latest/epel-7-$basearch/',
      gpgcheck      => 1,
      gpgkey        => 'https://copr-be.cloud.fedoraproject.org/results/maha/tor-latest/pubkey.gpg',
      repo_gpgcheck => 0,
      enabled       => 1,
      priority      => $priority,
  } -> Package<| title == 'tor' |>
}
