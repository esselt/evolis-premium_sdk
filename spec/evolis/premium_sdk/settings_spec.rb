require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Settings do
    let(:resource) { Settings.new HOST, PORT }

    it '#new is class Print' do
      expect(resource).to be_kind_of(Settings)
    end

    context 'no session' do
      it '#export raise NoActiveSessionError' do
        expect{resource.export}.to raise_error(Error::NoActiveSessionError)
      end

      it '#import raise NoActiveSessionError' do
        expect{resource.import}.to raise_error(Error::NoActiveSessionError)
      end

      it '#get raise NoActiveSessionError' do
        expect{resource.get 'GDuplexMode'}.to raise_error(Error::NoActiveSessionError)
      end

      it '#set raise NoActiveSessionError' do
        expect{resource.set 'GDuplexMode', 'SIMPLEX'}.to raise_error(Error::NoActiveSessionError)
      end

      describe '#begin' do
        it "device #{DEVICE} returns session id" do
          expect(resource.begin DEVICE).to be_kind_of(String)
          resource.end
        end

        it 'invalid device __ERROR__ raise ServerError' do
          expect{resource.begin '__ERROR__'}.to raise_error(Error::ServerError)
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

      describe '#import' do
        it 'invalid format __ERROR__ raise InvalidImportFormatError' do
          expect{resource.import '__ERROR__'}.to raise_error(Error::InvalidImportFormatError)
        end

        it 'no format returns true' do
          expect(resource.import).to be true
        end

        it 'format printer returns true' do
          expect(resource.import 'printer').to be true
        end

        it 'format xml and invalid base64 raise Base64FormatError' do
          expect{resource.import 'xml', 'bad base64'}.to raise_error(Error::Base64FormatError)
        end
      end

      describe '#export' do
        it 'invalid format __ERROR__ raise InvalidExportFormatError' do
          expect{resource.export '__ERROR__'}.to raise_error(Error::InvalidExportFormatError)
        end

        it 'format printer raise ServerError (before import)' do
          expect{resource.export 'printer'}.to raise_error(Error::ServerError, /import not done/)
        end

        it 'format printer returns true (after import)' do
          resource.import 'printer'
          expect(resource.export 'printer').to be true
        end

        it 'format text returns Array (after import)' do
          resource.import 'printer'
          expect(resource.export 'text').to be_kind_of(Array)
        end

        it 'format xml returns String (after import)' do
          resource.import 'printer'
          expect(resource.export 'xml').to be_kind_of(String)
        end
      end

      describe '#get' do
        it 'invalid key __ERROR__ raise InvalidPrintSettingError' do
          expect{resource.get '__ERROR__'}.to raise_error(Error::InvalidPrintSettingError)
        end

        it 'key GDuplexMode returns string' do
          expect(resource.get 'GDuplexMode').to be_kind_of(String)
        end
      end

      describe '#set' do
        it 'invalid key __ERROR__=SIMPLEX raise InvalidPrintSettingError' do
          expect{resource.set '__ERROR__', 'SIMPLEX'}.to raise_error(Error::InvalidPrintSettingError)
        end

        it 'invalid value GDuplexMode=__ERROR__ raise InvalidPrintSettingError' do
          expect{resource.set 'GDuplexMode', '__ERROR__'}.to raise_error(Error::InvalidPrintSettingError)
        end

        # Possible errors in actually setting on live systems
        #expect(resource.set 'GDuplexMode', 'SIMPLEX').to be true
      end
    end
  end
end