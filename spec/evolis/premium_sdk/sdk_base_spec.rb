require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe SdkBase do
    let(:resource) { SdkBase.new HOST, PORT, 'BASE' }
    let(:bmp) { 'base64:Qk1-AAAAAAAAAHoAAABsAAAAAQAAAAEAAAABABgAAAAAAAQAAAATCwAAEwsAAAAAAAAAAAAAQkdScwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAD___8A' }

    describe '#valid_settings?' do
      it 'invalid setting __ERROR__==__ERROR__ returns false' do
        expect(resource.valid_settings? '__ERROR__=__ERROR__').to be false
      end

      it 'invalid setting GDuplexMode=__ERROR__ returns false' do
        expect(resource.valid_settings? 'GDuplexMode=__ERROR__').to be false
      end

      it 'invalid setting __ERROR__ returns false' do
        expect(resource.valid_settings? 'GDuplexMode').to be false
      end

      it 'invalid setting __ERROR__ (key_only) returns false' do
        expect(resource.valid_settings? '__ERROR__', true).to be false
      end

      it 'setting GDuplexMode=SIMPLEX returns true' do
        expect(resource.valid_settings? 'GDuplexMode=SIMPLEX').to be true
      end

      it 'array of valid settings returns true' do
        settings = %w[GDuplexMode=SIMPLEX GInputTray=FEEDER]
        expect(resource.valid_settings? settings).to be true
      end

      it 'string of valid settings returns true' do
        settings = 'GDuplexMode=SIMPLEX;GInputTray=FEEDER'
        expect(resource.valid_settings? settings).to be true
      end

      it 'array of invalid settings returns true' do
        settings = %w[GDuplexMode=SIMPLEX GInputTray=__ERROR__]
        expect(resource.valid_settings? settings).to be true
      end

      it 'string of invalid settings returns true' do
        settings = 'GDuplexMode=SIMPLEX;GInputTray=__ERROR__'
        expect(resource.valid_settings? settings).to be true
      end
    end

    describe '#print_setting' do
      it 'invalid setting __ERROR__ raise InvalidPrintSettingError' do
        expect{resource.print_setting '__ERROR__'}.to raise_error(Error::InvalidPrintSettingError)
      end

      it 'valid setting GDuplexMode returns String' do
        expect(resource.print_setting 'GDuplexMode').to be_kind_of(String)
      end
    end

    it '#list_settings returns Hash' do
      expect(resource.list_settings).to be_kind_of(Hash)
    end

    describe '#valid_base64?' do
      it 'not string returns false' do
        expect(resource.valid_base64? %w[hello world]).to be false
      end

      it 'invalid base64 returns false' do
        expect(resource.valid_base64? "__ERROR__#{bmp}").to be false
      end

      it 'valid base64 returns true' do
        expect(resource.valid_base64? bmp).to be true
      end
    end
  end
end