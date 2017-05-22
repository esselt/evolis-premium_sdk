require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Espf < SdkBase
      def initialize(host, port)
        super(host, port, 'ESPF')
      end

      def get_param(key)
        raise Error::InvalidParamError.new key unless valid_param?(key)

        call_rpc('GetParam', {
            key: key
        })
      end

      def set_param(key, value)
        raise Error::InvalidParamError.new "#{key}=#{value}" unless valid_param?(key, value)

        call_rpc('SetParam', {
            key:  key,
            data: value
        })
      end

      def valid_param?(key, value = nil)
        params = value ? WRITE_PARAMS : READ_PARAMS.merge(WRITE_PARAMS)

        return false unless params.has_key?(key.to_sym)

        if value
          return false if value.is_a?(String) && value.empty?
          return false if params[key.to_sym].is_a?(Array) && !params[key.to_sym].include?(value)
          return false if params[key.to_sym].is_a?(Regexp) && value !~ params[key.to_sym]
        end

        return true
      end

      WRITE_PARAMS = {
          'ESPFServerManager.port': /^[1-9][0-9]+$/,
          'ESPFTcpServerConnectionSupervisor.receivetimeout': /^[1-9][0-9]*$/,
          'ESPFServerManager.tcpenabled': %w[true false]
      }

      READ_PARAMS = {
          'ESPFService.version': true,
          'ESPFService.requestlanguageversion': true
      }
    end
  end
end