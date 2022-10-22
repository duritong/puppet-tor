require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon::automap_hosts_on_resolve', :type => 'define' do
  let(:default_facts) {
    {
      :os => {
        :family => 'Debian',
        :name   => 'Debian',
      }
    }
  }
  let(:title){ 'test_os' }
  let(:facts){ default_facts }
  let(:pre_condition){'Exec{path => "/bin"}
                      include ::tor' }
  context 'with standard' do
    it { is_expected.to compile.with_all_deps }
  end
  context 'with set to false' do
    let(:params){
      {
        :automap_hosts_on_resolve => false,
      }
    }
    it { is_expected.to compile.with_all_deps }
  end
end
