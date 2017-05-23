require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Cmd < SdkBase
      # Default timeout for CMD service
      TIMEOUT = '3000'

      # Initializes the class and sets SDK host and port
      #
      # @param host [String] host or IP for SDK
      # @param port [String, Fixnum] port for SDK
      def initialize(host, port)
        super(host, port, 'CMD')
      end

      # Sends commands in text or binary format
      #
      # @param device [String] printer name
      # @param command [String] command, in clear text or base64-encoded format
      # @param timeout [String] communication timeout
      # @return [String] response to the sent command
      def send_command(device, command, timeout = TIMEOUT)
        call_rpc('SendCommand', {
            command: command,
            timeout: timeout,
            device:  device
        })
      end

      # Retrieves the binary status of a device
      #
      # @param device [String] printer name
      # @return [String] binary status of the device, see SDK document
      def get_status(device)
        call_rpc('GetStatus', {
            device: device
        })
      end

      # Reset communications with a device
      #
      # @param device [String] printer name
      # @param timeout [String] communication timeout
      # @return [true] if reset successful
      def reset_com(device, timeout = TIMEOUT)
        call_rpc('ResetCom', {
            timeout: timeout,
            device:  device
        })
      end
    end
  end
end
