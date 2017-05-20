require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Settings < SdkBase
      def initialize(host, port)
        super(host, port, 'SETTINGS')
      end

      def begin(device)
        active_session call_rpc('Begin', {
            device: device
        })
      end

      def export(format = 'printer')
        raise Error::NoActiveSessionError.new            unless active_session?
        raise Error::InvalidExportFormatError.new format unless %w[printer text xml].include?(format.downcase!)

        response = call_rpc('Export', {
            session: active_session,
            format:  format
        })

        return response.split(';') if format == 'text'
      end

      def import(format = 'printer', data = nil)
        raise Error::NoActiveSessionError.new            unless active_session?
        raise Error::InvalidExportFormatError.new format unless %w[printer text xml].include?(format.downcase!)
        raise Error::Base64FormatError.new data          if format == 'xml'

        params = {
            session: active_session,
            format:  format
        }
        params[:data] = data if format == 'xml'

        call_rpc('Import', params)
      end

      def get(key)
        raise Error::NoActiveSessionError.new         unless active_session?
        raise Error::InvalidPrintSettingError.new key unless valid_settings?(key, true)

        call_rpc('Get', {
            session: active_session,
            data:    key
        })
      end

      def set(key, value)
        raise Error::NoActiveSessionError.new unless active_session?
        raise Error::InvalidPrintSettingError.new key unless valid_settings?("#{key}=#{value}")

        call_rpc('Set', {
            session: active_session,
            data:    "#{key}=#{value}"
        })
      end

      def end
        raise Error::NoActiveSessionError.new unless active_session?

        call_rpc('End', {
            session: active_session
        })
      end
    end
  end
end