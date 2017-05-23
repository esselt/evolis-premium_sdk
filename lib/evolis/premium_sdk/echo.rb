require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Echo < SdkBase

      # Initializes the class and sets SDK host and port
      #
      # @param host [String] host or IP for SDK
      # @param port [String, Fixnum] port for SDK
      def initialize(host, port)
        super(host, port, 'ECHO')
      end

      # Sends a character string to the server
      #
      # @param msg [String] character string
      # @return [String] same as msg parameter
      def echo(msg)
        call_rpc('Echo', {
            data: msg
        })
      end
    end
  end
end