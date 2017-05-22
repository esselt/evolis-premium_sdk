require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Error do
    it 'raise InvalidResponse' do
      expect{raise Error::InvalidResponse.new}
          .to raise_error(
                  Error::InvalidResponse,
                  /(invalid)*(response)/i
              )
    end

    it 'raise InvalidJSON' do
      expect{raise Error::InvalidJSON.new 'Invalid JSON'}
          .to raise_error(
                  Error::InvalidJSON,
                  /Invalid JSON/
              )
    end

    it 'raise ServerError' do
      expect{raise Error::ServerError.new 123, 'Server error'}
          .to raise_error(
                  Error::ServerError,
                  /(123)*(Server error)/,
              )
    end

    it 'raise Base64FormatError' do
      expect{raise Error::Base64FormatError.new 'Bad base64'}
          .to raise_error(
                  Error::Base64FormatError,
                  /Bad base64/,
              )
    end

    it 'raise NoActiveSessionError' do
      expect{raise Error::NoActiveSessionError.new}
          .to raise_error(
                  Error::NoActiveSessionError,
                  /(active)*(session)/,
              )
    end

    it 'raise InvalidPrintSettingError' do
      expect{raise Error::InvalidPrintSettingError.new 'Invalid Setting'}
          .to raise_error(
                  Error::InvalidPrintSettingError,
                  /Invalid Setting/,
              )
    end

    it 'raise NoSuchFaceError' do
      expect{raise Error::NoSuchFaceError.new 'Wrong face'}
          .to raise_error(
                  Error::NoSuchFaceError,
                  /Wrong face/,
              )
    end

    it 'raise NoSuchPanelError' do
      expect{raise Error::NoSuchPanelError.new 'Wrong panel'}
          .to raise_error(
                  Error::NoSuchPanelError,
                  /Wrong panel/,
              )
    end

    it 'raise InvalidExportFormatError' do
      expect{raise Error::InvalidExportFormatError.new 'Invalid format'}
          .to raise_error(
                  Error::InvalidExportFormatError,
                  /Invalid format/,
              )
    end

    it 'raise InvalidImportFormatError' do
      expect{raise Error::InvalidImportFormatError.new 'Invalid format'}
          .to raise_error(
                  Error::InvalidImportFormatError,
                  /Invalid format/,
              )
    end

    it 'raise InvalidStateLevelError' do
      expect{raise Error::InvalidStateLevelError.new 'No such level'}
          .to raise_error(
                  Error::InvalidStateLevelError,
                  /No such level/,
              )
    end

    it 'raise InvalidEventError' do
      expect{raise Error::InvalidEventError.new 'No such event'}
          .to raise_error(
                  Error::InvalidEventError,
                  /No such event/,
              )
    end

    it 'raise InvalidActionError' do
      expect{raise Error::InvalidActionError.new 'No such action'}
          .to raise_error(
                  Error::InvalidActionError,
                  /No such action/,
              )
    end

    it 'raise InvalidParamError' do
      expect{raise Error::InvalidParamError.new 'Invalid parameter'}
          .to raise_error(
                  Error::InvalidParamError,
                  /Invalid parameter/,
              )
    end
  end
end