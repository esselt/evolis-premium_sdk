require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Settings < SdkBase
      def initialize(host, port)
        super(host, port, 'SETTINGS')
      end

      def begin(device)
        @session = call('Begin', {
            device: device
        })
      end

      def export(session = @session, format = 'printer')
        response = call('Export', {
            session: session,
            format:  format
        })

        return response.split(';') if format == 'text'
      end

      def import(session = @session, format = 'printer', data = nil)
        params = {
            session: session,
            format:  format
        }
        params[:data] = data if format == 'xml'

        call('Import', params)
      end

      def get(key, session = @session)
        call('Get', {
            session: session,
            data:    key
        })
      end

      def set(key, value, session = @session)
        call('Set', {
            session: session,
            data:    "#{key}=#{value}"
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