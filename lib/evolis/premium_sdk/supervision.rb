require 'evolis/premium_sdk/sdk_base'

module Evolis
  module PremiumSdk
    class Supervision < SdkBase
      def initialize(host, port)
        super(host, port, 'SUPERVISION')
      end

      def list(device, level = 2)
        raise Error::InvalidStateLevelError.new level unless (0..2).cover?(level)

        call_rpc('List', {
            device: device,
            level:  String(level)
        }).split(';')
      end

      def add_device(device)
        call_rpc('AddDevice', {
            device: device
        })
      end

      def remove_device(device)
        call_rpc('RemoveDevice', {
            device: device
        })
      end

      def get_state(device)
        call_rpc('GetState', {
            device: device
        }).split(',')
      end

      def get_event(device)
        event, actions = call_rpc('GetEvent', {
            device: device
        }).split(':')

        return event, actions.split(',')
      end

      def set_event(device, event, action)
        raise Error::InvalidEventError.new event unless validate_event?(event.upcase!)
        raise Error::InvalidActionError.new action unless %w[CANCEL OK RETRY].include?(action.upcase!)

        call_rpc('SetEvent', {
            action: "#{event}:#{action}",
            device: device
        })
      end

      def list_states
        return {
            ERROR: ERROR_EVENTS,
            WARNING: WARNING_EVENTS,
            READY: READY_EVENTS,
            OFF: OFF_EVENTS
        }
      end

      def print_state(event)
        list_states.each do |status, events|
          return events[event.to_sym] if events.has_key?[event.to_sym]
        end
      end

      private

      def validate_event?(event)
        return ERROR_EVENTS.merge(WARNING_EVENTS).has_key?(event.upcase!)
      end

      ERROR_EVENTS = {
          ERR_BLANK_TRACK: [
              'Magnetic encoding failed',
              'Encoding fails on this card, please check the card position in the feeder.'
          ],
          ERR_COVER_OPEN: [
              'Cover open error',
              'The cover was opened during the printing cycle. Close the cover and click on resume.'
          ],
          ERR_HEAD_TEMP: [
              'Too high temperature',
              'Print head temperature too high - wait until it cools down.'
          ],
          ERR_HOPPER_FULL: [
              'Output Hopper Full',
              'Please remove all the printed cards from the output hopper to resume printing.'
          ],
          ERR_MAGNETIC_DATA: [
              'Magnetic encoding failed',
              'Invalid data format.'
          ],
          ERR_MECHANICAL: [
              'Mechanical error',
              'A mechanical error has occurred.'
          ],
          ERR_READ_MAGNETIC: [
              'Magnetic encoding failed',
              'Magnetic track reading failed.'
          ],
          ERR_REJECT_BOX_FULL: [
              'Reject Box Full',
              'Please remove all the cards from the reject hopper to resume printing.'
          ],
          ERR_RIBBON_ERROR: [
              'Ribbon problem',
              'The ribbon is cut or stuck to the card.'
          ],
          ERR_WRITE_MAGNETIC: [
              'Magnetic encoding failed',
              'Read-after-Write failure.'
          ],
          'FEEDER_EMPTY (ERR_FEEDER_ERROR)': [
              'Card feed problem',
              'Please check cards, position in the card feeder and gauge adjustment.'
          ],
          INF_WRONG_ZONE_EXPIRED: [
              'Ribbon not valid',
              'Compatibility problem between ribbon and printouts credit limit reached. Please contact your reseller.'
          ],
          'RIBBON_ENDED (ERR)': [
              'Ribbon end',
              'Ribbon end, please replace by a new one.'
          ],
          'LAMINATE_END (ERR)': [
              'Film end',
              'Film end. Please replace the film.'
          ],
          ERR_LAMINATE: [
              'Film problem',
              'Film problem. The film is cut or stuck to the card.'
          ],
          ERR_LAMI_MECHANICAL: [
              'Mechanical error',
              'A mechanical error has occurred in the lamination module.'
          ],
          ERR_LAMI_TEMPERATURE: [
              'Temperature error',
              'The lamination module encountered a temperature error.'
          ],
          ERR_LAMI_COVER_OPEN: [
              'Door open during lamination',
              'The lamination module door got opened during the lamination process. Please close it and retry.'
          ]
      }

      WARNING_EVENTS = {
          INF_RIBBON_LOW: [
              'Ribbon close to the end',
              'Ribbon close to the end, please proceed with replenishment.'
          ],
          INF_FEEDER_NEAR_EMPTY: [
              'Feeder almost empty',
              'The card feeder is almost empty, please refill.'
          ],
          BUSY: [
              'Printer busy',
              'You cannot print while the printer is busy. Please wait or click on "Cancel".'
          ],
          CFG_FLIP: [
              'Single-sided Printer',
              'Your single-sided printer cannot print your dual- sided design.'
          ],
          CFG_MAGNETIC: [
              'Magnetic coding option not installed',
              'To continue printing without magnetic coding click on resume.'
          ],
          CFG_EXTENDED_RESOLUTION: [
              'Incompatible parameter',
              'This resolution parameter is not compatible with this printer / ribbon.'
          ],
          DEF_CARD_ON_EJECT: [
              'Remove card',
              'Remove the card from the manual feeder.'
          ],
          DEF_COOLING: [
              'Cooling in progress',
              'Printer cooling in progress.'
          ],
          DEF_COVER_OPEN: [
              'Cover open',
              'Close your printer cover.'
          ],
          DEF_HOPPER_FULL: [
              'Output Hopper Full',
              'Please remove all the printed cards from the output hopper to resume printing.'
          ],
          DEF_NO_RIBBON: [
              'No ribbon',
              'Replace the ribbon.'
          ],
          DEF_PRINTER_LOCKED: [
              'Communication with the printer is locked',
              'Contact your dealer'
          ],
          DEF_UNSUPPORTED_RIBBON: [
              'Ribbon incompatible with this printer model',
              'The ribbon inserted cannot work with this printer model.'
          ],
          DEF_WAIT_CARD: [
              'Waiting for a card insertion',
              'Please insert your card manually.'
          ],
          ERR_BAD_RIBBON: [
              'Ribbon installed is incompatible with settings',
              'The ribbon installed does not correspond to the manuallly defined settings. Printing cannot take place.'
          ],
          'FEEDER_EMPTY (DEF)': [
              'Card feed problem',
              'Please check cards, position in the card feeder and gauge adjustment.'
          ],
          INF_CLEANING_ADVANCED: [
              'Advanced cleaning required',
              'Printer advanced cleaning is required.'
          ],
          INF_CLEANING_LAST_OUTWARRANTY: [
              'Regular cleaning mandatory',
              'Click on "Cancel" and proceed with cleaning immediately. Would you continue, this will void the print head warranty.'
          ],
          INF_CLEANING_REQUIRED: [
              'Regular cleaning mandatory - No card issuance allowed by your Administrator',
              'Click on "Cancel" and proceed with cleaning immediately.'
          ],
          'INF_UNKNOWN_RIBBON (1)': [
              'Ribbon not identified',
              'Ribbon identification impossible. Please proceed with Manual settings.'
          ],
          'INF_UNKNOWN_RIBBON (2)': [
              'Ribbon not identified',
              'Ribbon identification impossible. Please proceed with Manual settings.'
          ],
          INF_WRONG_ZONE_ALERT: [
              'Ribbon not valid',
              'Compatibility problem between ribbon and printer. Less than 50 printouts remaining. Please contact your reseller.'
          ],
          INF_WRONG_ZONE_RIBBON: [
              'Ribbon not valid',
              'Compatibility problem between ribbon and printer. Please contact your reseller.'
          ],
          'RIBBON_ENDED (DEF)': [
              'Ribbon end',
              'Ribbon end, please replace by a new one.'
          ],
          DEF_NO_LAMINATE: [
              'No film',
              'No film in lamination module. Please replace the film.'
          ],
          INF_LAMINATE_UNKNOWN: [
              'Film not identified',
              'Unknown film. Please contact your reseller.'
          ],
          INF_LAMINATE_LOW: [
              'Film close to the end',
              'Film close to the end. Please arrange for replacement.'
          ],
          'LAMINATE_END (DEF)': [
              'Film end',
              'Film end. Please replace the film.'
          ],
          DEF_LAMINATE_UNSUPPORTED: [
              'Incompatible film',
              'Film incompatible with lamination module. Please contact your reseller.'
          ],
          DEF_LAMI_COVER_OPEN: [
              'Door open',
              'Lamination module door open. Close the lamination module door.'
          ],
          INF_LAMI_TEMP_NOT_READY: [
              'Adjusting temperature',
              'Lamination module temperature adjustment in progress. Please wait...'
          ],
          DEF_LAMI_HOPPER_FULL: [
              'Output jammed',
              'The lamination output is jammed. Please remove the card(s) and retry.'
          ]
      }

      READY_EVENTS = {
          INF_CLEANING: [
              'Regular cleaning required'
          ],
          'INF_CLEANING (INF_CLEAN_2ND_PASS)': [
              'Insert your adhesive cleaning card',
              'Please insert your sticky cleaning card. "Cancel" if you want to proceed with printing.'
          ],
          INF_CLEANING_RUNNING: [
              'Cleaning in progress'
          ],
          INF_ENCODING_RUNNING: [
              'Encoding in progress'
          ],
          INF_PRINTING_RUNNING: [
              'Printing in progress'
          ],
          INF_LAMINATING_RUNNING: [
              'Lamination in progress'
          ],
          INF_LAMI_CLEANING_RUNNING: [
              'Lamination module cleaning in progress'
          ],
          INF_LAMI_UPDATING_FIRMWARE: [
              'Lamination module firmware update in progress'
          ],
          INF_SLEEP_MODE: [
              'Printer in Standby mode'
          ],
          INF_UPDATING_FIRMWARE: [
              'Firmware update in progress'
          ],
          NOT_FLIP_ACT: [
              'Single-sided Printer'
          ],
          PRINTER_READY: [
              'Printer ready'
          ]
      }

      OFF_EVENTS = {
          PRINTER_NOT_SUPERVISED: [
              'Not supervised by Evolis Print Center'
          ],
          PRINTER_OFFLINE: [
              'Printer offline'
          ],
          PRINTER_STATUS_DISABLED: [
              'Status disabled - Printer on-line'
          ]
      }
    end
  end
end
