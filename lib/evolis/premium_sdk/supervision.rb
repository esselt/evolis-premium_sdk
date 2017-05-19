require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Supervision < SdkBase
      def initialize(host, port)
        super(host, port, 'SUPERVISION')
      end

      def list(device, level = 2)
        call('List', {
            device: device,
            level:  String(level)
        }).split(';')
      end

      def add_device(device)
        call('AddDevice', {
            device: device
        })
      end

      def remove_device(device)
        call('RemoveDevice', {
            device: device
        })
      end

      def get_state(device)
        call('GetState', {
            device: device
        }).split(',')
      end

      def get_event(device)
        call('GetEvent', {
            device: device
        }).split(':')
      end

      def set_event(device, event, action)
        call('SetEvent', {
            action: "#{event}:#{action}",
            device: device
        })
      end
    end
  end
end
