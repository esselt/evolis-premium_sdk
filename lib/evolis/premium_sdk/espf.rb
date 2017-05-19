require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Espf < SdkBase
      def initialize(host, port)
        super(host, port, 'ESPF')
      end

      def get_param(key)
        call('GetParam', {
            key: key
        })
      end

      def set_param(key, value)
        call('SetParam', {
            key:  key,
            data: value
        })
      end
    end
  end
end