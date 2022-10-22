require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))
require 'openssl'

describe 'tor::daemon::onion_service', :type => 'define' do
  let(:default_facts) {
    {
      :os => {
        :family => 'RedHat',
        :name   => 'CentOS',
      }
    }
  }
  let(:title){ 'test_os' }
  let(:facts){ default_facts }
  let(:pre_condition){'Exec{path => "/bin"}
                      include ::tor' }
  describe 'with standard' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with(
      :content => /HiddenServiceDir \/var\/lib\/tor\/test_os/,
      :order   => '05',
      :target  => '/etc/tor/torrc',
    )}
    it { is_expected.to_not contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort/) }
    it { is_expected.to_not contain_file('/var/lib/tor/test_os') }
    context 'on Debian' do
      let(:facts) {
        {
          :os => {
            :family => 'Debian',
            :name   => 'Debian',
          }
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with(
        :content => /HiddenServiceDir \/var\/lib\/tor\/test_os/,
        :order   => '05',
        :target  => '/etc/tor/torrc',
      )}
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServiceVersion 3/) }
      it { is_expected.to_not contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort/) }
      it { is_expected.to_not contain_file('/var/lib/tor/test_os') }
    end
    context 'with differt port params' do
      let(:params){
        {
          :ports => ['25', '443 192.168.0.1:8443']
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServiceVersion 3/) }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort 25/) }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort 443 192.168.0.1:8443/) }
      it { is_expected.to_not contain_file('/var/lib/tor/test_os') }
    end
    # rspec-puppet does not yet support testing with sensitive data
    # See https://github.com/rodjek/rspec-puppet/milestone/8 for upcoming support
    context 'with v3 private key to generate' do
      let(:params){
        {
          :ports                  => ['80'],
          :private_key_name       => 'test_os',
          :private_key_store_path => File.expand_path(File.join(File.dirname(__FILE__),'..','tmp')),
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServiceVersion 3/) }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort 80/) }
      it { is_expected.to contain_file('/var/lib/tor/test_os').with(
        :ensure  => 'directory',
        :purge   => true,
        :force   => true,
        :recurse => true,
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :require => 'Package[tor]',
      )}
      it { is_expected.to contain_file('/var/lib/tor/test_os/hostname').with(
        :content => /^[a-z2-7]{56}\.onion\n/,
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :notify  => 'Service[tor]',
      )}
      it { is_expected.to contain_file('/var/lib/tor/test_os/hs_ed25519_secret_key').with(
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :notify  => 'Service[tor]',
      )}
      it { is_expected.to contain_file('/var/lib/tor/test_os/hs_ed25519_public_key').with(
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :notify  => 'Service[tor]',
      )}
    end
  end
end
