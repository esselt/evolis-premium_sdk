require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Print < SdkBase
      def initialize(host, port)
        super(host, port, 'PRINT')
      end

      def begin(device)
        @session = call('Begin', {
            device: device
        })
      end

      def set(session = @session, data)
        data = [data] unless data.is_a?(Array)
        call('Set', {
            session: session,
            data:    data.join(';')
        })
      end

      def set_bitmap(session = @session, face = 'front', panel = 'color', data)
        call('SetBitmap', {
            session: session,
            face:    face,
            panel:   panel,
            data:    data
        })
      end

      def print(session = @session)
        call('Print', {
            session: session
        })
      end

      def end(session = @session)
        call('End', {
            session: session
        })
      end
    end
  end
end