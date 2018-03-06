require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))
require 'openssl'

describe 'tor::daemon::onion_service', :type => 'define' do
  let(:default_facts) {
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS',
    }
  }
  let(:title){ 'test_os' }
  let(:facts){ default_facts }
  let(:pre_condition){'Exec{path => "/bin"}
                      include tor::daemon' }
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
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with(
        :content => /HiddenServiceDir \/var\/lib\/tor\/test_os/,
        :order   => '05',
        :target  => '/etc/tor/torrc',
      )}
      it { is_expected.to_not contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort/) }
      it { is_expected.to_not contain_file('/var/lib/tor/test_os') }
    end
    context 'with differt port params' do
      let(:params){
        {
          :ports => ['25','443 192.168.0.1:8443']
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort 25 127.0.0.1:25/) }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort 443 192.168.0.1:8443/) }
      it { is_expected.to_not contain_file('/var/lib/tor/test_os') }
    end
    context 'with private_key' do
      let(:params){
        {
          :ports       => ['80'],
          :private_key => OpenSSL::PKey::RSA.generate(1024).to_s,
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort 80 127.0.0.1:80/) }
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
        :content => /^[a-z2-7]{16}\.onion\n/,
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :notify  => 'Service[tor]',
      )}
      it { is_expected.to contain_file('/var/lib/tor/test_os/private_key').with(
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :notify  => 'Service[tor]',
      )}
    end
    context 'with private key to generate' do
      let(:params){
        {
          :ports                  => ['80'],
          :private_key_name       => 'test_os',
          :private_key_store_path => File.expand_path(File.join(File.dirname(__FILE__),'..','tmp')),
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('05.onion_service.test_os').with_content(/^HiddenServicePort 80 127.0.0.1:80/) }
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
        :content => /^[a-z2-7]{16}\.onion\n/,
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :notify  => 'Service[tor]',
      )}
      it { is_expected.to contain_file('/var/lib/tor/test_os/private_key').with(
        :owner   => 'toranon',
        :group   => 'toranon',
        :mode    => '0600',
        :notify  => 'Service[tor]',
      )}
    end
  end
end
