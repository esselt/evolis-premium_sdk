require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Supervision do
    let(:resource) { Supervision.new HOST, PORT }

    it '#new is class Print' do
      expect(resource).to be_kind_of(Supervision)
    end

    describe '#list' do
      it 'return array of printers' do
        expect(resource.list 'Evolis Primacy').to be_kind_of(Array)
      end

      it 'unknown model returns empty list' do
        expect(resource.list '__ERROR__').to be_empty
      end

      it 'level over 2 raise InvalidStateLevelError' do
        expect{resource.list 'Evolis Primacy', 3}.to raise_error(Error::InvalidStateLevelError)
      end
    end
  end
end