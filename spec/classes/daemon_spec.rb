require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon', :type => 'class' do
  let(:default_facts) {
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS',
    }
  }
  let(:facts){ default_facts }
  let(:pre_condition){'Exec{path => "/bin"}' }
  describe 'with standard' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('tor') }
    it { is_expected.to contain_class('tor::daemon::base') }
    it { is_expected.to_not contain_class('tor::munin') }
    context 'on Debian' do
      let(:facts) {
        {
          :osfamily        => 'Debian',
          :operatingsystem => 'Debian',
        }
      }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('tor') }
      it { is_expected.to contain_class('tor::daemon::base') }
      it { is_expected.to_not contain_class('tor::munin') }
    end
  end
end
