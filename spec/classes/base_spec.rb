require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::base', :type => 'class' do
  let(:default_facts) {
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS',
    }
  }
  let(:facts){ default_facts }
  let(:pre_condition){'include ::tor
                       Exec{path => "/bin"}' }
  describe 'with standard' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_package('tor').with_ensure('installed') }
    it { is_expected.to_not contain_package('tor-geoipdb').with_ensure('installed') }
    it { is_expected.to contain_service('tor').with(
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
      :hasstatus  => 'true',
      :require    => 'Package[tor]',
    ) }
    context 'on Debian' do
      let(:facts) {
        {
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('tor').with_ensure('installed') }
      it { is_expected.to contain_package('tor-geoipdb').with_ensure('installed') }
      it { is_expected.to contain_service('tor').with(
        :ensure     => 'running',
        :enable     => 'true',
        :hasrestart => 'true',
        :hasstatus  => 'true',
        :require    => 'Package[tor]',
      ) }
    end
  end
end
