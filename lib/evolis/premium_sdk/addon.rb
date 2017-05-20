require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Addon < SdkBase
      def initialize(host, port)
        super(host, port, 'ADDON')
      end

      def launch(command, data)
        call_rpc('Launch', {
            command: command,
            data:    data
        })
      end
    end
  end
end