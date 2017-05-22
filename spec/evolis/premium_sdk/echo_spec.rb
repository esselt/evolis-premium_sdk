require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Echo do
    let(:resource) { Echo.new HOST, PORT }

    it '#new is class Echo' do
      expect(resource).to be_kind_of(Echo)
    end

    describe '#echo' do
      it 'mirrors output' do
        msg = 'Mirror'
        expect(resource.echo msg).to eq(msg)
      end

      it 'empty is ok' do
        expect(resource.echo '').to eq('')
      end
    end
  end
end