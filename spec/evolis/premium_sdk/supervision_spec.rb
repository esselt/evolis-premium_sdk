require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Supervision do

    # Does not have the opportunity to test AddDevice and RemoveDevice, but should not be much errors there

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

    describe '#get_state' do
      it 'valid device' do
        expect(resource.get_state DEVICE).to be_truthy
      end

      it 'invalid device' do
        expect{resource.get_state '__ERROR__'}.to raise_error(Error::ServerError)
      end
    end

    describe '#get_event' do
      it 'valid device' do
        expect(resource.get_event DEVICE).to be_kind_of(Array)
      end

      it 'invalid device' do
        expect{resource.get_event '__ERROR__'}.to raise_error(Error::ServerError)
      end
    end

    describe '#set_event' do
      it 'invalid event' do
        expect{resource.set_event DEVICE, '__ERROR__', 'OK'}.to raise_error(Error::InvalidEventError)
      end

      it 'invalid action' do
        expect{resource.set_event DEVICE, 'INF_RIBBON_LOW', '__ERROR__'}.to raise_error(Error::InvalidActionError)
      end

      it 'valid event and action' do
        # Impossible to test before events occur
        #expect{resource.set_event DEVICE, 'INF_RIBBON_LOW', 'OK'}.to be(true)
      end
    end

    describe '#print_event' do
      it 'invalid event' do
        expect{resource.print_event '__ERROR__'}.to raise_error(Error::InvalidEventError)
      end

      it 'valid event' do
        expect(resource.print_event 'ERR_BLANK_TRACK').to be_kind_of(Array)
      end
    end

    describe '#validate_event?' do
      it 'non existent event' do
        expect(resource.validate_event? '__ERROR__').to be false
      end

      it 'non human actionable event' do
        expect(resource.validate_event? 'PRINTER_READY').to be false
      end

      it 'valid event' do
        expect(resource.validate_event? 'ERR_BLANK_TRACK').to be true
      end
    end
  end
end