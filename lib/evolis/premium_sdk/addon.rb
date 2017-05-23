require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Addon < SdkBase

      # Initializes the class and sets SDK host and port
      #
      # @param host [String] host or IP for SDK
      # @param port [String, Fixnum] port for SDK
      def initialize(host, port)
        super(host, port, 'ADDON')
      end

      # Executes an application on the server
      #
      # @param command [String] what command to launch
      # @param data [String] parameters to give to command
      # @return [String] results from command
      def launch(command, data)
        call_rpc('Launch', {
            command: command,
            data:    data
        })
      end
    end
  end
end