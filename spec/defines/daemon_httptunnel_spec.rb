require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon::httptunnel', :type => 'define' do
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
  describe 'with standard' do
    let(:params){
      {
        :port => 443,
      }
    }
    it { is_expected.to compile.with_all_deps }
    context 'with IPv4' do
      let(:params){
        {
          :port => '1.1.1.1:443',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
    context 'with IPv6' do
      let(:params){
        {
          :port => '[2001:0db8:85a3:0000:0000:8a2e:0370:7334]:443',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
  end
end
