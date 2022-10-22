require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'tor::daemon::snippet', :type => 'define' do
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
        :content => 'Foobar200',
      }
    }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat__fragment('99.snippet.test_os').with_content(/^Foobar200/) }
  end
end
