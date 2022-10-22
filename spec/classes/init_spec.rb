require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor', :type => 'class' do
  let(:default_facts) {
    {
      :os => {
        :family => 'RedHat',
        :name   => 'CentOS',
      }
    }
  }
  let(:facts){ default_facts }
  let(:pre_condition){'Exec{path => "/bin"}' }
  describe 'with standard' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('tor::install') }
    it { is_expected.to contain_class('tor::daemon::base') }
    it { is_expected.to contain_package('tor').with_ensure('installed') }
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
          :os => {
            :family => 'Debian',
            :name   => 'Debian',
          }
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('tor::install') }
      it { is_expected.to contain_class('tor::daemon::base') }
      it { is_expected.to contain_package('tor').with_ensure('installed') }
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
