require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon::map_address', :type => 'define' do
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
        :address    => '1.1.1.1',
        :newaddress => '2.2.2.2',
      }
    }
    it { is_expected.to compile.with_all_deps }
    context 'with fqdn' do
      let(:params){
        {
          :address    => 'www.foo.bar',
          :newaddress => 'www.bar.foo',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
  end
end
