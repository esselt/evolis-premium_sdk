require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Espf < SdkBase
      def initialize(host, port)
        super(host, port, 'ESPF')
      end

      def get_param(key)
        raise Error::InvalidParamError.new key if valid_param?(key)

        call_rpc('GetParam', {
            key: key
        })
      end

      def set_param(key, value)
        raise Error::InvalidParamError.new "#{key}=#{value}" if valid_param?(key, value)

        call_rpc('SetParam', {
            key:  key,
            data: value
        })
      end

      private

      def valid_param?(key, value = nil)
        return false unless PARAMS.has_key?(key.to_sym)

        if value
          return false if value.is_a?(String) and value.empty?
          return false if PARAMS[key.to_sym].is_a?(Array) and !PARAMS[key.to_sym].include?(value)
          return false if PARAMS[key.to_sym].is_a?(Class) and !value.is_a?(PARAMS[key.to_sym])
          return false if PARAMS[key.to_sym].is_a?(Regexp) and value !~ PARAMS[key.to_sym]
        end

        return true
      end

      PARAMS = {
          'ESPFService.log': %w[true false],
          'ESPFService.loglevel': /^[1-7]&/,
          'ESPFService.logrequest': %w[true false],
          'ESPFService.logrequestoutputdir': String,
          'ESPFService.isrelativeoutputdir': %w[true false],
          'ESPFServerManager.serveraddress': String,
          'ESPFServerManager.uniqueid': String,
          'ESPFServerManager.disablepipeserver': %w[true false],
          'ESPFServerManager.port': /^[1-9][0-9]+&/,
          'ESPFServerManager.enabletcpatstart': %w[true false],
          'ServiceAddOnManager.enabled': %w[true false],
          'ServiceAddOnManager.addondir': String,
          'ServiceAddOnManager.isrelativeaddondir': %w[true false],
      }
    end
  end
end