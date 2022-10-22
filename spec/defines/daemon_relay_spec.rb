require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon::relay', :type => 'define' do
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
    it { is_expected.to compile.with_all_deps }
    context 'with family' do
      let(:params){
        {
          :my_family => 'good folks',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
    context 'with bridge relay' do
      let(:params){
        {
          :bridge_relay => true,
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
    context 'with port' do
      let(:params){
        {
          :port => 443,
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
    context 'with IPv4 port' do
      let(:params){
        {
          :port => '1.1.1.1:443',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
    context 'with IPv6 port' do
      let(:params){
        {
          :port => '[2001:0db8:85a3:0000:0000:8a2e:0370:7334]:443',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
  end
  describe 'with port' do
    let(:params){
      {
        :port => 443,
      }
    }
    context 'with outbound bind addresses' do
      let(:params){
        {
          :outbound_bindaddresses => ['1.1.1.1', '2001:0db8:85a3:0000:0000:8a2e:0370:7334'],
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
    context 'with other options' do
      let(:params){
        {
          :nickname              => 'johnny',
          :address               => 'example.com',
          :bandwidth_rate        => 1000,
          :bandwidth_burst       => 1000,
          :relay_bandwidth_rate  => 1000,
          :relay_bandwidth_burst => 1000,
          :accounting_max        => 1000,
          :accounting_start      => 'month 2 0:00',
          :contact_info          => 'knock on my door',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
  end
end
