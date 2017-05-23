require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Setting < SdkBase

      # Initializes the class and sets SDK host and port
      #
      # @param host [String] host or IP for SDK
      # @param port [String, Fixnum] port for SDK
      def initialize(host, port)
        super(host, port, 'SETTING')
      end

      # Starts a configuration session
      #
      # @param device [String] printer name
      # @return [String] session id
      def begin(device)
        self.active_session = call_rpc('Begin', {
            device: device
        })
      end

      # Exports parameters
      #
      # @param format [String] format to export settings, `printer`, `text` or `xml`
      # @return [true] on success with format `printer`
      # @return [Array] of setting=value pairs on format `text`
      # @return [String] base64 encoded xml
      # @raise [Error::NoActiveSessionError] if no active session
      # @raise [Error::InvalidExportFormatError] when format is invalid
      def export(format = 'printer')
        raise Error::NoActiveSessionError.new            unless active_session?
        raise Error::InvalidExportFormatError.new format unless %w[printer text xml].include?(format.downcase)

        resp = call_rpc('Export', {
            session: self.active_session,
            format:  format
        })

        return resp.split(';') if format == 'text'
        return resp
      end

      # Imports parameters
      #
      # @param format [String] format to import settings, `printer`, `default` or `xml`
      # @param data [nil, String] base64 encoded xml on format `xml`
      # @return [true] on successful import
      # @raise [Error::NoActiveSessionError] if no active session
      # @raise [Error::InvalidImportFormatError] when format is invalid
      # @raise [Error::Base64FormatError] on format `xml` and invalid base64 data
      def import(format = 'printer', data = nil)
        raise Error::NoActiveSessionError.new            unless active_session?
        raise Error::InvalidImportFormatError.new format unless %w[printer default xml].include?(format.downcase)
        raise Error::Base64FormatError.new data          if format == 'xml'

        params = {
            session: self.active_session,
            format:  format
        }
        params[:data] = data if format == 'xml'

        call_rpc('Import', params)
      end

      # Gets the value of a parameter
      #
      # @param key [String] setting to read
      # @return [String] value of setting
      # @raise [Error::NoActiveSessionError] if no active session
      # @raise [Error::InvalidPrintSettingError] on invalid key
      def get(key)
        raise Error::NoActiveSessionError.new         unless active_session?
        raise Error::InvalidPrintSettingError.new key unless valid_settings?(key, true)

        call_rpc('Get', {
            session: self.active_session,
            data:    key
        })
      end

      # Edits the value of a parameter
      #
      # @param key [String] setting to set
      # @param value [String] value for setting
      # @return [true] if set successful
      # @raise [Error::NoActiveSessionError] if no active session
      # @raise [Error::InvalidPrintSettingError] if key=value pair does not validate
      def set(key, value)
        raise Error::NoActiveSessionError.new unless active_session?
        raise Error::InvalidPrintSettingError.new key unless valid_settings?("#{key}=#{value}")

        call_rpc('Set', {
            session: self.active_session,
            data:    "#{key}=#{value}"
        })
      end

      # Ends the session
      #
      # @return [true] if ended session
      # @raise [Error::NoActiveSessionError] if no active session
      def end
        raise Error::NoActiveSessionError.new unless active_session?

        call_rpc('End', {
            session: self.active_session
        })
      end
    end
  end
end