require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Cmd < SdkBase
      TIMEOUT = '3000'

      def initialize(host, port)
        super(host, port, 'CMD')
      end

      def send_command(device, command, timeout = TIMEOUT)
        call_rpc('SendCommand', {
            command: command,
            timeout: timeout,
            device:  device
        })
      end

      def get_status(device)
        call_rpc('GetStatus', {
            device: device
        })
      end

      def reset_com(device, timeout = TIMEOUT)
        call_rpc('ResetCom', {
            timeout: timeout,
            device:  device
        })
      end
    end
  end
end
