require 'spec_helper'

RSpec.describe Evolis::PremiumSdk::Error do
  it 'raise InvalidResponse' do
    expect{raise Evolis::PremiumSdk::Error::InvalidResponse.new}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidResponse,
                /(invalid)*(response)/i
            )
  end

  it 'raise InvalidJSON' do
    expect{raise Evolis::PremiumSdk::Error::InvalidJSON.new 'Invalid JSON'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidJSON,
                /Invalid JSON/
            )
  end

  it 'raise ServerError' do
    expect{raise Evolis::PremiumSdk::Error::ServerError.new 123, 'Server error'}
        .to raise_error(
                Evolis::PremiumSdk::Error::ServerError,
                /(123)*(Server error)/,
            )
  end

  it 'raise Base64FormatError' do
    expect{raise Evolis::PremiumSdk::Error::Base64FormatError.new 'Bad base64'}
        .to raise_error(
                Evolis::PremiumSdk::Error::Base64FormatError,
                /Bad base64/,
            )
  end

  it 'raise NoActiveSessionError' do
    expect{raise Evolis::PremiumSdk::Error::NoActiveSessionError.new}
        .to raise_error(
                Evolis::PremiumSdk::Error::NoActiveSessionError,
                /(active)*(session)/,
            )
  end

  it 'raise InvalidPrintSettingError' do
    expect{raise Evolis::PremiumSdk::Error::InvalidPrintSettingError.new 'Invalid Setting'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidPrintSettingError,
                /Invalid Setting/,
            )
  end

  it 'raise NoSuchFaceError' do
    expect{raise Evolis::PremiumSdk::Error::NoSuchFaceError.new 'Wrong face'}
        .to raise_error(
                Evolis::PremiumSdk::Error::NoSuchFaceError,
                /Wrong face/,
            )
  end

  it 'raise NoSuchPanelError' do
    expect{raise Evolis::PremiumSdk::Error::NoSuchPanelError.new 'Wrong panel'}
        .to raise_error(
                Evolis::PremiumSdk::Error::NoSuchPanelError,
                /Wrong panel/,
            )
  end

  it 'raise InvalidExportFormatError' do
    expect{raise Evolis::PremiumSdk::Error::InvalidExportFormatError.new 'Invalid format'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidExportFormatError,
                /Invalid format/,
            )
  end

  it 'raise InvalidImportFormatError' do
    expect{raise Evolis::PremiumSdk::Error::InvalidImportFormatError.new 'Invalid format'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidImportFormatError,
                /Invalid format/,
            )
  end

  it 'raise InvalidStateLevelError' do
    expect{raise Evolis::PremiumSdk::Error::InvalidStateLevelError.new 'No such level'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidStateLevelError,
                /No such level/,
            )
  end

  it 'raise InvalidEventError' do
    expect{raise Evolis::PremiumSdk::Error::InvalidEventError.new 'No such event'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidEventError,
                /No such event/,
            )
  end

  it 'raise InvalidActionError' do
    expect{raise Evolis::PremiumSdk::Error::InvalidActionError.new 'No such action'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidActionError,
                /No such action/,
            )
  end

  it 'raise InvalidParamError' do
    expect{raise Evolis::PremiumSdk::Error::InvalidParamError.new 'Invalid parameter'}
        .to raise_error(
                Evolis::PremiumSdk::Error::InvalidParamError,
                /Invalid parameter/,
            )
  end
end