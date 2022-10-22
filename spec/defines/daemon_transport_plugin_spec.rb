require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon::transport_plugin', :type => 'define' do
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
    context 'with options' do
      let(:params){
        {
          :servertransport_plugin     => 'string1',
          :servertransport_listenaddr => 'string2',
          :servertransport_options    => 'string3',
          :ext_port                   => 443,
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
    context 'with obsf4 config' do
      let(:params){
        {
          :servertransport_plugin     => 'obfs4 exec /usr/bin/obfs4proxy',
          :servertransport_listenaddr => 'obfs4 0.0.0.0:80',
          :ext_port                   => 'auto',
        }
      }
      it { is_expected.to compile.with_all_deps }
    end
  end
end
