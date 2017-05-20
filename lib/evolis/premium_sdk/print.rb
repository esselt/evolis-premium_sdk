require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Print < SdkBase
      def initialize(host, port)
        super(host, port, 'PRINT')
      end

      def begin(device)
        active_session call_rpc('Begin', {
            device: device
        })
      end

      def set(data)
        raise Error::NoActiveSessionError.new          unless active_session?
        raise Error::InvalidPrintSettingError.new data unless valid_settings?(data)

        data = [data] unless data.is_a?(Array)
        call_rpc('Set', {
            session: active_session,
            data:    data.join(';')
        })
      end

      def set_bitmap(face = 'front', panel = 'color', data)
        raise Error::NoActiveSessionError.new   unless active_session?
        raise Error::NoSuchFaceError.new face   unless %w[front back].include?(face.downcase!)
        raise Error::NoSuchPanelError.new panel unless %w[color resin varnish].include?(panel.downcase!)
        raise Error::Base64FormatError.new data unless valid_base64?(data)

        call_rpc('SetBitmap', {
            session: active_session,
            face:    face,
            panel:   panel,
            data:    data
        })
      end

      def print
        raise Error::NoActiveSessionError.new unless active_session?

        call_rpc('Print', {
            session: active_session
        })
      end

      def end
        raise Error::NoActiveSessionError.new unless active_session?

        call_rpc('End', {
            session: active_session
        })
      end
    end
  end
end