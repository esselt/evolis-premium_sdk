require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Supervision do
    let(:resource) { Supervision.new HOST, PORT }

    # Does not have the opportunity to test AddDevice and RemoveDevice, but should not be much errors there

    it '#new is class Print' do
      expect(resource).to be_kind_of(Supervision)
    end

    describe '#list' do
      it 'return Array of printers' do
        expect(resource.list 'Evolis Primacy').to be_kind_of(Array)
      end

      it 'unknown model returns empty Array' do
        expect(resource.list '__ERROR__').to be_empty
      end

      it 'level over 2 raise InvalidStateLevelError' do
        expect{resource.list 'Evolis Primacy', 3}.to raise_error(Error::InvalidStateLevelError)
      end
    end

    describe '#get_state' do
      it "device #{DEVICE} returns state of printer" do
        expect(resource.get_state DEVICE).to be_truthy
      end

      it 'invalid device __ERROR__ raise Error::ServerError' do
        expect{resource.get_state '__ERROR__'}.to raise_error(Error::ServerError)
      end
    end

    describe '#get_event' do
      it "device #{DEVICE} returns Array of event state" do
        expect(resource.get_event DEVICE).to be_kind_of(Array)
      end

      it 'invalid device __ERROR__ raise ServerError' do
        expect{resource.get_event '__ERROR__'}.to raise_error(Error::ServerError)
      end
    end

    describe '#set_event' do
      it 'invalid event __ERROR__ raise InvalidEventError' do
        expect{resource.set_event DEVICE, '__ERROR__', 'OK'}.to raise_error(Error::InvalidEventError)
      end

      it 'invalid action __ERROR__ raise InvalidActionError' do
        expect{resource.set_event DEVICE, 'INF_RIBBON_LOW', '__ERROR__'}.to raise_error(Error::InvalidActionError)
      end

      # Impossible to test before events occur
      #expect{resource.set_event DEVICE, 'INF_RIBBON_LOW', 'OK'}.to be(true)
    end

    describe '#print_event' do
      it 'invalid event __ERROR__ raise InvalidEventError' do
        expect{resource.print_event '__ERROR__'}.to raise_error(Error::InvalidEventError)
      end

      it 'valid event ERR_BLANK_TRACK returns Array of descriptions' do
        expect(resource.print_event 'ERR_BLANK_TRACK').to be_kind_of(Array)
      end
    end

    describe '#validate_event?' do
      it 'non existent event __ERROR__ returns false' do
        expect(resource.validate_event? '__ERROR__').to be false
      end

      it 'non human actionable event PRINTER_READY returns false' do
        expect(resource.validate_event? 'PRINTER_READY').to be false
      end

      it 'valid event ERR_BLANK_TRACK returns true' do
        expect(resource.validate_event? 'ERR_BLANK_TRACK').to be true
      end
    end
  end
end