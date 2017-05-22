require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Cmd do
    let(:resource) { Cmd.new HOST, PORT }

    it '#new' do
      expect(resource).to be_kind_of(Cmd)
    end

    describe '#send_command' do
      it 'command Rfv responds with result' do
        expect(resource.send_command DEVICE, 'Rfv').to be_kind_of(String)
      end

      it 'command __ERROR__ responds with "ERROR CDE"' do
        expect(resource.send_command DEVICE, '__ERROR__').to eq('ERROR CDE')
      end

      it 'device __ERROR__ raise ServerError' do
        expect{resource.send_command '__ERROR__', 'Rfv'}.to raise_error(Error::ServerError)
      end
    end

    describe '#get_status' do
      it "device #{DEVICE} responds with result" do
        expect(resource.get_status DEVICE).to be_kind_of(String)
      end

      it 'device __ERROR__ raise ServerError' do
        expect{resource.get_status '__ERROR__'}.to raise_error(Error::ServerError)
      end
    end

    describe '#reset_com' do
      it "device #{DEVICE} respond true" do
        expect(resource.reset_com DEVICE).to be true
      end

      it 'device __ERROR__ raise ServerError' do
        expect{resource.reset_com '__ERROR__'}.to raise_error(Error::ServerError)
      end
    end
  end
end