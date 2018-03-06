require 'spec_helper'
require 'fileutils'

describe 'generate_onion_key' do
  before(:all) do
    @tmp_path = File.expand_path(File.join(File.dirname(__FILE__),'..','fixtures','tmp'))
    @test_path = File.join(@tmp_path,'test.key')
    @drpsyff5srkctr7h_str = "-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQC9OUBOkL73n43ogC/Jma54/ZZDEpoisqpkGJHgbcRGJIxcqqfL
PbnT3hD5SUCVXxLnzWDCTwTe2VOzIUlBXmslwVXnCJh/XGZg9NHiNU3EAZTwu1g9
8gNmmG1bymaoEBkuC1osijOj+CN+gzLzApiMbDxddpxTn70LWaSqMDbfdQIDAQAB
An88nBn9EGAa8QCDeIvWB2PbXV7EHTFB6/ioFzairIYx8YMEK6WTdDIRqw/EybHm
Jo3nseFMXAMzXmlw9zh/t76ZzE7ooYocSPIEzpu4gDRsa5/mqRCGajs8A8ooiHN5
Tc9cHzIfhjOYhu3VxF0G9LTAC8nKdWQkHm+h+J6A6+wBAkEA2E6GcIdPGTSfaNRS
BHOpKUUSvH7W0e5fyYe221EhESdTFjVkaO5YN9HvcqYh27nik0azKgNj6PiE01FC
0q4fgQJBAN/ycGS3dX5WRXEOpbQ04LKyxCFMVgS+tN5ueDgbv/SxWAxidLYcVfbg
CcUA+L2OaQ95S97CxYlCLda10vIPOfUCQQCUvQJzFIgOlAHdqsovJ3011Lp6hVmg
h6K0SK8zhkkPq5PVnKdMBEEDOUfG9XgoyFyF20LN7ADirSlgyesCRhuBAkEAmuCE
MmNecn0fkUzb9IENVQik85JjeuyZEau8oLEwU/3CMu50YO2/1fijSQee/xlaN0Vf
3zM8geyu3urodFdrcQJBAMBcecMvo4ddZ/GnwpKJuXEhKSwQfPOeb8lK12NvKuVE
znq+qT/KbJlwy/27X/auCAzD5rJ9VVzyWiu8nnwICS8=
-----END RSA PRIVATE KEY-----\n"
  end
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /requires 2 arguments/) }
    it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, /requires 2 arguments/) }
    it { is_expected.to run.with_params('/etc/passwd','test').and_raise_error(Puppet::ParseError, /requires location \(\/etc\/passwd\) to be a directory/) }
    describe 'with a key bigger than 1024' do
      before(:each) do
        FileUtils.mkdir_p(@tmp_path) unless File.directory?(@tmp_path)
        File.open(@test_path,'w'){|f| f << OpenSSL::PKey::RSA.generate(2048) }
      end
      it { is_expected.to run.with_params(@tmp_path,'test').and_raise_error(Puppet::ParseError, /must have a length of 1024bit/) }
    end
  end

  describe 'normal operation' do
    before(:all) do
      FileUtils.rm_rf(@tmp_path) if File.exists?(@tmp_path)
      FileUtils.mkdir_p(@tmp_path)
    end
    after(:all) do
      FileUtils.rm_rf(@tmp_path) if File.exists?(@tmp_path)
    end
    let(:return_value) {
      scope.function_generate_onion_key([@tmp_path,'test'])
    }
    context 'without an existing key' do
      it 'returns an onion address and a key ' do
        expect(return_value.size).to be(2)
      end
      it 'creates and stores the key' do
        expect(return_value.last).to be_eql(File.read(File.join(@tmp_path,'test.key')))
      end
      it 'returns a proper onion address' do
        expect(return_value.first).to be_eql(scope.function_onion_address([File.read(File.join(@tmp_path,'test.key'))]))
      end
      it 'does not recreate a key once created' do
        expect(scope.function_generate_onion_key([@tmp_path,'test'])).to be_eql(scope.function_generate_onion_key([@tmp_path,'test']))
      end
      it 'creates to different keys for different names' do
        expect(scope.function_generate_onion_key([@tmp_path,'test']).first).to_not be_eql(scope.function_generate_onion_key([@tmp_path,'test2']))
      end
    end
    context 'with an existing key' do
      before(:all) do
        File.open(File.join(@tmp_path,'test3.key'),'w'){|f| f << @drpsyff5srkctr7h_str }
      end
      it { is_expected.to run.with_params(@tmp_path,'test3').and_return(['drpsyff5srkctr7h',@drpsyff5srkctr7h_str]) }
    end
  end
end
