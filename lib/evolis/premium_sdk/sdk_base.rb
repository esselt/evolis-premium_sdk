require 'evolis/premium_sdk/rpc_client'

module Evolis
  module PremiumSdk
    class SdkBase
      attr_accessor :active_session

      def initialize(host, port, service)
        @rpc = RpcClient.new(host, port)
        @service = service
      end

      def call_rpc(method, args)
        method = sanitize_parameters(method)
        args   = sanitize_parameters(args)
        resp   = @rpc.call("#{@service}.#{method}", args)

        return true if resp == 'OK'
        return resp
      end

      def response
        @rpc.response
      end

      def request
        @rpc.request
      end

      SETTINGS = {
          GDuplexMode: %w[SIMPLEX DUPLEX_CC DUPLEX_CM DUPLEX_MC DUPLEX_MM],
          GInputTray: %w[FEEDER AUTO MANUAL PRINTER],
          GOutputTray: %w[HOPPER REAR PRINTER],
          GRejectBox: %w[DEFAULTREJECT HOPPER PRINTER],
          GRibbonType: %w[RC_YMCKO RC_YMCKOS RC_YMCKOK RC_YMCKOKOS RM_KO RM_KBLACK RM_KWHITE RM_KRED RM_KGREEN RM_KBLUE RM_KSCRATCH RM_KMETALSILVER RM_KMETALGOLD RM_KSIGNATURE RM_KWAX RM_KPREMIUM RM_HOLO],
          GShortPanelManagement: %w[AUTO CUSTOM OFF],
          GSmoothing: %w[STDSMOOTH ADVSMOOTH NOSMOOTH],
          IGStrictPageSetup: %w[ON OFF],
          FBlackManagement: %w[NOBLACKPOINT ALLBLACKPOINT TEXTINBLACK],
          BBlackManagement: %w[NOBLACKPOINT ALLBLACKPOINT TEXTINBLACK],
          FColorBrightness: (1..20).to_a.map! { |i| "VAL#{i}" },
          BColorBrightness: (1..20).to_a.map! { |i| "VAL#{i}" },
          FColorContrast: (1..20).to_a.map! { |i| "VAL#{i}" },
          BColorContrast: (1..20).to_a.map! { |i| "VAL#{i}" },
          FHalftoning: %w[THRESHOLD FLOYD DITHERING CLUSTERED_DITHERING],
          BHalftoning: %w[THRESHOLD FLOYD DITHERING CLUSTERED_DITHERING],
          FMonochromeContrast: (1..20).to_a.map! { |i| "VAL#{i}" },
          BMonochromeContrast: (1..20).to_a.map! { |i| "VAL#{i}" },
          FOverlayContrast: (1..20).to_a.map! { |i| "VAL#{i}" },
          BOverlayContrast: (1..20).to_a.map! { |i| "VAL#{i}" },
          FOverlayManagement: %w[NOVARNISH FULLVARNISH BMPVARNISH],
          BOverlayManagement: %w[NOVARNISH FULLVARNISH BMPVARNISH],
          FPageRotate180: %w[ON OFF],
          BPageRotate180: %w[ON OFF],
          GMagCoercivity: %w[OFF LOCO HICO],
          GMagT1Encoding: %w[ISO1 ISO2 ISO3 SIPASS C2 JIS2 C4 NONE],
          GMagT2Encoding: %w[ISO1 ISO2 ISO3 SIPASS C2 JIS2 C4 NONE],
          GMagT3Encoding: %w[ISO1 ISO2 ISO3 SIPASS C2 JIS2 C4 NONE],
          Track1Data: String,
          Track2Data: String,
          Track3Data: String,
          Resolution: %w[DPI300 DPI600300 DPI1200300],
          IShortPanelShift: /^[0-9]+$/,
          Passthrough: String,
          RawData: String,
      }

      def valid_settings?(settings, key_only = false)
        settings = [settings] unless settings.is_a?(Array)
        settings.each do |pair|
          return false unless pair.include?('=')
          setting, value = pair.split('=')

          return false unless SETTINGS.has_key?(setting.to_sym)

          unless key_only
            return false if !value
            return false if value.is_a?(String) && value.empty?
            return false if SETTINGS[setting.to_sym].is_a?(Array) && !SETTINGS[setting.to_sym].include?(value)
            return false if SETTINGS[setting.to_sym].is_a?(Class) && !value.is_a?(SETTINGS[setting.to_sym])
            return false if SETTINGS[setting.to_sym].is_a?(Regexp) && value.is_a?(String) && value !~ SETTINGS[setting.to_sym]
          end

          return true
        end
      end

      def valid_base64?(string)
        return false unless string.is_a?(String)
        return false unless string.start_with?('base64:')

        return true
      end

      def active_session?
        return false unless self.active_session
        return false if self.active_session == nil
        return false unless self.active_session.is_a?(String)
        return false if self.active_session.empty?

        return true
      end

      def sanitize_parameters(param)
        return param.map { |p| String(p) }                      if param.is_a?(Array)
        return param.map { |k, v| [String(k), String(v)] }.to_h if param.is_a?(Hash)
        return String(param)
      end
    end
  end
end