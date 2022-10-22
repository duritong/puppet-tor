require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon::bridge', :type => 'define' do
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
        :ip   => '1.1.1.1',
        :port => 443,
      }
    }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_concat__fragment('11.bridge.test_os').with(
      :order   => '11',
      :target  => '/etc/tor/torrc',
    )}
    context 'with IPv4' do
      let(:params){
        {
          :ip   => '1.1.1.1',
          :port => 443,
        }
      }
      it { is_expected.to compile.with_all_deps }
      #it { is_expected.to contain_concat__fragment('11.bridge.test_os').with_content("# Bridge test_os\nBridge [1.1.1.1]:443") }
    end
    context 'with IPv6' do
      let(:params){
        {
          :ip   => '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
          :port => 443,
        }
      }
      it { is_expected.to compile.with_all_deps }
      #it { is_expected.to contain_concat__fragment('11.bridge.test_os').with_content("# Bridge test_os\nBridge [2001:0db8:85a3:0000:0000:8a2e:0370:7334]:443") }
    end
    context 'with fingerprint' do
      let(:params){
        {
          :ip          => '1.1.1.1',
          :port        => 443,
          :fingerprint => '9695DFC35FFEB861329B9F1AB04C46397020CE31',
        }
      }
      it { is_expected.to compile.with_all_deps }
      #it { is_expected.to contain_concat__fragment('11.bridge.test_os').with_content("# Bridge test_os\nBridge [1.1.1.1]:443 9695DFC35FFEB861329B9F1AB04C46397020CE31") }
    end
    context 'with transport plugin' do
      let(:params){
        {
          :ip        => '1.1.1.1',
          :port      => 443,
          :transport => 'obfs4 exec /usr/bin/obfs4proxy',
        }
      }
      it { is_expected.to compile.with_all_deps }
      #it { is_expected.to contain_concat__fragment('11.bridge.test_os').with_content("# Bridge test_os\nBridge obfs4 exec \/usr\/bin\/obfs4proxy [1.1.1.1]:443") }
    end
  end
end
