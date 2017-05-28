require 'evolis/premium_sdk/rpc_client'

module Evolis
  module PremiumSdk
    class SdkBase
      # @return [String] returns the active session
      attr_accessor :active_session

      # Initalizes the class, sets default options
      #
      # @param host [String] host or ip to Premium SDK API
      # @param port [String, Fixnum] port to Premium SDK API
      # @param service [String] servicename, used only internally (e.g. CMD or PRINT)
      def initialize(host, port, service)
        @rpc = RpcClient.new(host, port)
        @service = service
      end

      # Makes the call to the API and returns results
      #
      # @param method [String] method name for the service
      # @param args [String] arguments and parameters to send to service
      # @return [String] returns result parameter from the response
      # @return [true] if result is "OK"
      def call_rpc(method, args)
        method = sanitize_parameters(method)
        args   = sanitize_parameters(args)
        resp   = @rpc.call("#{@service}.#{method}", args)

        return true if resp == 'OK'
        return resp
      end

      # Method to lookup the full response
      # @return [Hash] full json response
      # @return [nil] before first response
      def response
        @rpc.response
      end

      # Method to lookup the full request
      # @return [Hash] full json request
      # @return (nil) before first request
      def request
        @rpc.request
      end

      # Settings and their values allowed to be used when getting and setting settings for print
      SETTINGS = {
          GDuplexMode: {
              validation: %w[SIMPLEX DUPLEX_CC DUPLEX_CM DUPLEX_MC DUPLEX_MM],
              description: 'Front side and Back side settings'
          },
          GInputTray: {
              validation: %w[FEEDER AUTO MANUAL PRINTER],
              description: 'Card insertion'
          },
          GOutputTray: {
              validation: %w[HOPPER REAR PRINTER],
              description: 'Card exit'
          },
          GRejectBox: {
              validation: %w[DEFAULTREJECT HOPPER PRINTER],
              description: 'Rejected error card'
          },
          GRibbonType: {
              validation: %w[RC_YMCKO RC_YMCKOS RC_YMCKOK RC_YMCKOKOS RM_KO RM_KBLACK RM_KWHITE RM_KRED RM_KGREEN RM_KBLUE RM_KSCRATCH RM_KMETALSILVER RM_KMETALGOLD RM_KSIGNATURE RM_KWAX RM_KPREMIUM RM_HOLO],
              description: 'Ribbon type'
          },
          GShortPanelManagement: {
              validation: %w[AUTO CUSTOM OFF],
              description: 'Short panel management mode'
          },
          GSmoothing: {
              validation: %w[STDSMOOTH ADVSMOOTH NOSMOOTH],
              description: 'Smoothing mode'
          },
          IGStrictPageSetup: {
              validation: %w[ON OFF],
              description: 'Strict page setup mode'
          },
          FBlackManagement: {
              validation: %w[NOBLACKPOINT ALLBLACKPOINT TEXTINBLACK],
              description: 'Black panel management mode (front)'
          },
          BBlackManagement: {
              validation: %w[NOBLACKPOINT ALLBLACKPOINT TEXTINBLACK],
              description: 'Black panel management mode (back)'
          },
          FColorBrightness: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Brightness adjustment for color panel (front)'
          },
          BColorBrightness: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Brightness adjustment for color panel (back)'
          },
          FColorContrast: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Contrast adjustment for color panel (front)'
          },
          BColorContrast: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Contrast adjustment for color panel (back)'
          },
          FHalftoning: {
              validation: %w[THRESHOLD FLOYD DITHERING CLUSTERED_DITHERING],
              description: 'Black panel adjustment (front)'
          },
          BHalftoning: {
              validation: %w[THRESHOLD FLOYD DITHERING CLUSTERED_DITHERING],
              description: 'Black panel adjustment (back)'
          },
          FMonochromeContrast: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Monochrome resin adjustment (front)'
          },
          BMonochromeContrast: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Monochrome resin adjustment (back)'
          },
          FOverlayContrast: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Varnish adjustment (front)'
          },
          BOverlayContrast: {
              validation: (1..20).to_a.map! { |i| "VAL#{i}" },
              description: 'Varnish adjustment (back)'
          },
          FOverlayManagement: {
              validation: %w[NOVARNISH FULLVARNISH BMPVARNISH],
              description: 'Varnish type (front)'
          },
          BOverlayManagement: {
              validation: %w[NOVARNISH FULLVARNISH BMPVARNISH],
              description: 'Varnish type (back)'
          },
          FPageRotate180: {
              validation: %w[ON OFF],
              description: 'Rotate by 180° (front)'
          },
          BPageRotate180: {
              validation: %w[ON OFF],
              description: 'Rotate by 180° (back)'
          },
          GMagCoercivity: {
              validation: %w[OFF LOCO HICO],
              description: 'Magnetic coercivity'
          },
          GMagT1Encoding: {
              validation: %w[ISO1 ISO2 ISO3 SIPASS C2 JIS2 C4 NONE],
              description: 'Magnetic Track 1 mode'
          },
          GMagT2Encoding: {
              validation: %w[ISO1 ISO2 ISO3 SIPASS C2 JIS2 C4 NONE],
              description: 'Magnetic Track 2 mode'
          },
          GMagT3Encoding: {
              validation: %w[ISO1 ISO2 ISO3 SIPASS C2 JIS2 C4 NONE],
              description: 'Magnetic Track 3 mode'
          },
          Track1Data: {
              validation: String,
              description: 'Magnetic track 1 data'
          },
          Track2Data: {
              validation: String,
              description: 'Magnetic track 2 data'
          },
          Track3Data: {
              validation: String,
              description: 'Magnetic track 3 data'
          },
          Resolution: {
              validation: %w[DPI300 DPI600300 DPI1200300],
              description: 'Resolution'
          },
          IShortPanelShift: {
              validation: /^[0-9]+$/,
              description: 'Short panel management shift'
          },
          Passthrough: {
              validation: String,
              description: 'Passthrough/Raw data'
          },
          RawData: {
              validation: String,
              description: 'Passthrough/Raw data'
          }
      }

      # Checks if settings supplied are valid
      #
      # @param settings [String, Array] setting and value,
      #   as "setting=value;setting2=value2" or ["setting=value","setting2=value2"]
      # @param key_only [true, false] used for checking if only setting without value. Set to true for setting only.
      # @return [true, false] true if valid settings, false if not
      def valid_settings?(settings, key_only = false)
        settings = settings.split(';') if settings.include?(';')
        settings = [settings] unless settings.is_a?(Array)

        settings.each do |pair|
          if key_only
            setting = pair
          else
            return false unless pair.include?('=')
            setting, value = pair.split('=')
          end

          return false unless SETTINGS.has_key?(setting.to_sym)

          unless key_only
            return false if !value
            return false if value.is_a?(String) && value.empty?
            return false if SETTINGS[setting.to_sym][:validation].is_a?(Array) && !SETTINGS[setting.to_sym][:validation].include?(value)
            return false if SETTINGS[setting.to_sym][:validation].is_a?(Class) && !value.is_a?(SETTINGS[setting.to_sym][:validation])
            return false if SETTINGS[setting.to_sym][:validation].is_a?(Regexp) && value.is_a?(String) && value !~ SETTINGS[setting.to_sym][:validation]
          end

          return true
        end
      end

      # @return [String] string of description or false if setting does not exist
      # @raise [Error::InvalidPrintSettingError] on invalid print setting
      def print_setting(setting)
        return SETTINGS[setting.to_sym][:description] if SETTINGS.has_key?(setting.to_sym)
        raise Error::InvalidPrintSettingError.new setting
      end

      # @return [Hash] of settings with descriptions
      def list_settings
        return SETTINGS.map{ |key, value| [key, value[:description]] }.to_h
      end

      # Basic checking for valid base64 string, as used in the SDK
      #
      # @param string [String] the base64 encoded data
      # @return [true, false] true if valid base64 string, false if not
      def valid_base64?(string)
        return false unless string.is_a?(String)
        return false unless string.start_with?('base64:')

        return true
      end

      # Checks if there is an active session
      # @return [true, false] true if exist, false if not
      def active_session?
        return false unless self.active_session
        return false if self.active_session == nil
        return false unless self.active_session.is_a?(String)
        return false if self.active_session.empty?

        return true
      end

      # Sanitizes parameters so they're not anything other than a String
      #
      # @param param [Any type] parameters to be sanitized
      # @return [Hash, Array, String] Hash and Array get sanitized and returned as Hash and Array,
      #   everything else becomes a String
      def sanitize_parameters(param)
        return param.map { |p| String(p) }                      if param.is_a?(Array)
        return param.map { |k, v| [String(k), String(v)] }.to_h if param.is_a?(Hash)
        return String(param)
      end
    end
  end
end