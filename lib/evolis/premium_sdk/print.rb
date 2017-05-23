require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Print < SdkBase

      # Initializes the class and sets SDK host and port
      #
      # @param host [String] host or IP for SDK
      # @param port [String, Fixnum] port for SDK
      def initialize(host, port)
        super(host, port, 'PRINT')
      end

      # Initiates a printing session
      #
      # @param device [String] printer name
      # @return [String] session id
      def begin(device)
        self.active_session = call_rpc('Begin', {
            device: device
        })
      end

      # Sets the printing parameters
      #
      # @param data [String, Array] print settings as "setting=value;setting2=value2"
      #   or ["setting=value","setting2"="value2"]
      # @return [true] if set successful
      # @raise [Error::NoActiveSessionError] if no active session
      # @raise [Error::InvalidPrintSettingError] on invalid print settings
      def set(data)
        raise Error::NoActiveSessionError.new          unless active_session?
        raise Error::InvalidPrintSettingError.new data unless valid_settings?(data)

        data = data.join(';') if data.is_a?(Array)
        call_rpc('Set', {
            session: self.active_session,
            data:    data
        })
      end

      # Defines the graphic data to be printed
      # @note Can only be run once per card side and panel type
      #
      # @param data [String] base64 encoded bitmap information, must start with `base64`
      # @param face [String] card face to print on, `front` or `back`
      # @param panel [String] panel type to print, `color`, `resin` or `varnish`
      # @return [true] if added successful
      # @raise [Error::NoActiveSessionError] if no active session
      # @raise [Error::NoSuchFaceError] when face is not recognized
      # @raise [Error::NoSuchPanelError] on unknown panel type
      # @raise [Error::Base64FormatError] if data does not validate to base64 format
      def set_bitmap(data, face = 'front', panel = 'color')
        raise Error::NoActiveSessionError.new   unless active_session?
        raise Error::NoSuchFaceError.new face   unless %w[front back].include?(face.downcase)
        raise Error::NoSuchPanelError.new panel unless %w[color resin varnish].include?(panel.downcase)
        raise Error::Base64FormatError.new data unless valid_base64?(data)

        call_rpc('SetBitmap', {
            session: self.active_session,
            face:    face,
            panel:   panel,
            data:    data
        })
      end

      # Launches a printing job
      # @note When calling the `print`, the `get_event` method from the `Supervision` service must be polled on a
      #   regular basis. If an event is identified, an action must be taken so that the print job can be finalized.
      #
      # @return [true] if started printing
      # @raise [Error::NoActiveSessionError] if no active session
      def print
        raise Error::NoActiveSessionError.new unless active_session?

        call_rpc('Print', {
            session: self.active_session
        })
      end

      # Ends the session
      #
      # @return [true] if ended session
      # @raise [Error::NoActiveSessionError] if no active session
      def end
        raise Error::NoActiveSessionError.new unless active_session?

        call_rpc('End', {
            session: self.active_session
        })
      end
    end
  end
end