require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Espf < SdkBase

      # Initializes the class and sets SDK host and port
      #
      # @param host [String] host or IP for SDK
      # @param port [String, Fixnum] port for SDK
      def initialize(host, port)
        super(host, port, 'ESPF')
      end

      # Reads the value of a server parameter
      #
      # @param key [String] ESPF service parameter
      # @return [String] current value
      # @raise [Error::InvalidParamError] if the parameters supplied is not valid
      def get_param(key)
        raise Error::InvalidParamError.new key unless valid_param?(key)

        call_rpc('GetParam', {
            key: key
        })
      end

      # Edits the value of server parameter
      #
      # @param key [String] ESPF service parameter
      # @param value [String] value to be set
      # @return [true] if set as planned
      # @raise [Error::InvalidParamError] if the parameters supplied is not valid
      def set_param(key, value)
        raise Error::InvalidParamError.new "#{key}=#{value}" unless valid_param?(key, value)

        call_rpc('SetParam', {
            key:  key,
            data: value
        })
      end

      # Checks if the parameters supplied is valid
      #
      # @param key [String] ESPF service parameter
      # @param value [nil, false, String] nil/false when parameter only, String to run check on value
      # @return [true, false] true when validation succeeds and false when it does not
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

      # Parameters and values valid for setting
      WRITE_PARAMS = {
          'ESPFServerManager.port': /^[1-9][0-9]+$/,
          'ESPFTcpServerConnectionSupervisor.receivetimeout': /^[1-9][0-9]*$/,
          'ESPFServerManager.tcpenabled': %w[true false]
      }

      # Parameters valid for reading
      READ_PARAMS = {
          'ESPFService.version': true,
          'ESPFService.requestlanguageversion': true
      }
    end
  end
end