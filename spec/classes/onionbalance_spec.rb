require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::onionbalance', :type => 'class' do
  let(:default_facts) {
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS',
    }
  }
  let(:facts){ default_facts }
  let(:pre_condition){'Exec{path => "/bin"}' }
  let(:params){
    {
      :services  => {
        'keyname_of_service1' => {
          'name1'        => 'onionservice_addr_3',
          'name2'        => 'onionservice_addr_2',
          '_key_content' => 'content_of_key_of_onionbalanced_service1',
        },
      },
    }
  }
  describe 'with standard' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_package('python2-onionbalance').with(
      :ensure => 'installed',
    ) }
    it { is_expected.to contain_service('tor@onionbalance').with(
      :ensure => 'running',
      :enable => true,
    ) }
    it { is_expected.to contain_service('onionbalance').with(
      :ensure    => 'running',
      :enable    => true,
      :subscribe => 'Service[tor@onionbalance]',
    ) }
    context 'on Debian' do
      let(:facts) {
        {
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('onionbalance').with(
        :ensure => 'installed',
      ) }
      it { is_expected.to contain_service('tor@onionbalance').with(
        :ensure => 'running',
        :enable => true,
      ) }
      it { is_expected.to contain_service('onionbalance').with(
        :ensure    => 'running',
        :enable    => true,
        :subscribe => 'Service[tor@onionbalance]',
      ) }
    end
  end
end
