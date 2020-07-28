require 'spec_helper'
require 'fileutils'

describe 'tor::onionv3_key' do
  before(:all) do
    @tmp_path = File.expand_path(File.join(File.dirname(__FILE__),'..','fixtures','tmp'))
  end
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(ArgumentError, /expects 2 arguments/) }
    it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, /expects 2 arguments/) }
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
      call_function('tor::onionv3_key',@tmp_path,'test')
    }
    context 'without an existing key' do
      it 'returns an onion address, public and a secret key' do
        expect(return_value.size).to be(3)
      end
      ['hs_ed25519_secret_key','hs_ed25519_public_key','hostname'].each do |f|
        it "creates and stores the #{f}" do
          expect(return_value[f]).to be_eql(File.read(File.join(@tmp_path,'test',f)).chomp)
        end
      end
      it 'does not recreate a key once created' do
        expect(call_function('tor::onionv3_key',@tmp_path,'test')).to be_eql(call_function('tor::onionv3_key',@tmp_path,'test'))
      end
      it 'creates to different keys for different names' do
        expect(call_function('tor::onionv3_key',@tmp_path,'test')).to_not be_eql(call_function('tor::onionv3_key',@tmp_path,'test2'))
      end
    end
  end
end
