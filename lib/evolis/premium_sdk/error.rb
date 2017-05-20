module Evolis
  module PremiumSdk
    module Error
      class InvalidResponse < StandardError
        def initialize
          super('Invalid or empty response from server.')
        end
      end

      class InvalidJSON < StandardError
        def initialize(json)
          super("Couldn't parse JSON string received from server:\n#{json}")
        end
      end

      class ServerError < StandardError
        attr_reader :code, :response_error

        def initialize(code, message)
          @code = code
          @response_error = message
          super("Server error #{code}: #{message}")
        end
      end

      class Base64FormatError < StandardError
        def initialize(value)
          super("Value is not valid base64 format: #{value}")
        end
      end

      class NoActiveSessionError < StandardError
        def initialize
          super('Could not find active session.')
        end
      end

      class InvalidPrintSettingError < StandardError
        def initialize(value)
          super("Setting or value is invalid print settings: #{value}")
        end
      end

      class NoSuchFaceError < StandardError
        def initialize(face)
          super("Invalid face for printing: #{face}")
        end
      end

      class NoSuchPanelError < StandardError
        def initialize(panel)
          super("Invalid panel for printing: #{panel}")
        end
      end

      class InvalidExportFormatError < StandardError
        def initialize(format)
          super("Invalid format for exporting settings: #{format}")
        end
      end

      class InvalidImportFormatError < StandardError
        def initialize(format)
          super("Invalid format for importing settings: #{format}")
        end
      end

      class InvalidStateLevelError < StandardError
        def initialize(level)
          super("Invalid level for listing printer state: #{level}")
        end
      end

      class InvalidEventError < StandardError
        def initialize(event)
          super("Invalid event for setting state: #{event}")
        end
      end

      class InvalidActionError < StandardError
        def initialize(action)
          super("Invalid action for setting state: #{action}")
        end
      end

      class InvalidParamError < StandardError
        def initialize(param)
          super("Invalid parameter or value for ESPF service: #{param}")
        end
      end
    end
  end
end