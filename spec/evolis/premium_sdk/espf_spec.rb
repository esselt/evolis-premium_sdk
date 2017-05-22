require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Espf do
    let(:resource) { Espf.new HOST, PORT }

    it '#new is class Espf' do
      expect(resource).to be_kind_of(Espf)
    end

    describe '#get_param' do
      it 'ESPFService.version returns version' do
        expect(resource.get_param 'ESPFService.version').to be_truthy
      end

      it '__ERROR__ raises InvalidParamError' do
        expect{resource.get_param '__ERROR__'}.to raise_error(Error::InvalidParamError)
      end
    end

    describe '#set_param' do
      it 'ESPFServerManager.tcpenabled=true returns true' do
        expect(resource.set_param 'ESPFServerManager.tcpenabled', 'true').to be true
      end

      it 'ESPFServerManager.tcpenabled=__ERROR__ raise InvalidParamError' do
        expect{resource.set_param 'ESPFServerManager.tcpenabled', '__ERROR__'}.to raise_error(Error::InvalidParamError)
      end

      it '__ERROR__=18000 raise InvalidParamError' do
        expect{resource.set_param '__ERROR__', '18000'}.to raise_error(Error::InvalidParamError)
      end
    end

    describe '#valid_param?' do
      it 'invalid key' do
        expect(resource.valid_param? '__ERROR__').to be false
      end

      it 'valid key' do
        expect(resource.valid_param? 'ESPFService.version').to be true
      end

      describe 'validate array of elements' do
        it 'valid' do
          expect(resource.valid_param?('ESPFServerManager.tcpenabled', 'true')).to be true
        end

        it 'invalid' do
          expect(resource.valid_param?('ESPFServerManager.tcpenabled', '__ERROR__')).to be false
        end
      end

      describe 'validate regex match' do
        it 'valid' do
          expect(resource.valid_param?('ESPFServerManager.port', '18000')).to be true
        end

        it 'invalid' do
          expect(resource.valid_param?('ESPFServerManager.port', 'false')).to be false
        end
      end
    end
  end
end