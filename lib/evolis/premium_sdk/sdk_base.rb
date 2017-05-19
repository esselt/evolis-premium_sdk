require 'evolis/premium_sdk/rpc_client'

module Evolis
  module PremiumSdk
    class SdkBase
      def initialize(host, port, service)
        @rpc = RpcClient.new(host, port)
        @service = service
      end

      def call(method, args)
        resp = @rpc.call("#{@service.upcase}.#{method.capitalize}", args)

        return true if resp == 'OK'
      end

      def response
        @rpc.response
      end

      def request
        @rpc.request
      end
    end
  end
end