require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Print do
    let(:resource) { Print.new HOST, PORT }
    let(:bmp) { 'base64:Qk1-AAAAAAAAAHoAAABsAAAAAQAAAAEAAAABABgAAAAAAAQAAAATCwAAEwsAAAAAAAAAAAAAQkdScwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAD___8A' }

    it '#new is class Print' do
      expect(resource).to be_kind_of(Print)
    end

    context 'no session' do
      it '#end raise NoActiveSessionError' do
        expect{resource.end}.to raise_error(Error::NoActiveSessionError)
      end

      it '#print raise NoActiveSessionError' do
        expect{resource.print}.to raise_error(Error::NoActiveSessionError)
      end

      it '#set_bitmap raise NoActiveSessionError' do
        expect{resource.set_bitmap bmp}.to raise_error(Error::NoActiveSessionError)
      end

      it '#set raise NoActiveSessionError' do
        expect{resource.set 'GDuplexMode=SIMPLEX'}.to raise_error(Error::NoActiveSessionError)
      end

      describe '#begin' do
        after(:each) { resource.end }

        it "device #{DEVICE} should return session id" do
          expect(resource.begin DEVICE).to be_kind_of(String)
        end

        it 'invalid device __ERROR__ returns session id' do
          expect(resource.begin '__ERROR__').to be_kind_of(String)
        end
      end

      describe '#end' do
        before(:each) { resource.begin DEVICE }

        it { expect(resource.end).to be true }
      end
    end

    context 'with session' do
      before(:each) { resource.begin DEVICE }
      after(:each) { resource.end }

      describe '#set' do
        it 'invalid setting __ERROR__ raise InvalidPrintSettingError' do
          expect{resource.set '__ERROR__'}.to raise_error(Error::InvalidPrintSettingError)
        end

        it 'valid setting GDuplexMode=SIMPLEX returns true' do
          expect(resource.set 'GDuplexMode=SIMPLEX').to be true
        end
      end

      describe '#set_bitmap' do
        it 'invalid face __ERROR__ raise NoSuchFaceError' do
          expect{resource.set_bitmap bmp, '__ERROR__'}.to raise_error(Error::NoSuchFaceError)
        end

        it 'invalid panel __ERROR__ raise NoSuchPanelError' do
          expect{resource.set_bitmap bmp, 'front', '__ERROR__'}.to raise_error(Error::NoSuchPanelError)
        end

        it 'invalid base64 raise Base64FormatError' do
          expect{resource.set_bitmap "__ERROR__#{bmp}"}.to raise_error(Error::Base64FormatError)
        end

        it 'valid base64 returns true' do
          expect(resource.set_bitmap bmp).to be true
        end
      end

      describe '#print' do
        # Do not want to test as it uses cards
        #it { expect(resource.print).to be true }
      end
    end
  end
end