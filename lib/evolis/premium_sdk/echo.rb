require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Echo < SdkBase
      def initialize(host, port)
        super(host, port, 'ECHO')
      end

      def echo(msg)
        call('Echo', {
            data: msg
        })
      end
    end
  end
end