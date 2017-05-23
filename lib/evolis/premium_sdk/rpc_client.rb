require 'multi_json'
require 'socket'
require 'evolis/premium_sdk/error'

module Evolis
  module PremiumSdk
    class RpcClient
      # JSON-RPC version number
      JSON_RPC_VERSION = '2.0'

      # @return [Hash] the last request made to the API
      attr_reader :request

      # @return [Hash] the last response from API
      attr_reader :response

      # @return [String] randomly generated number between 10 and 12 digits
      def self.make_id
        String rand(10**12)
      end

      # Initializes the class and sets API host and port
      #
      # @param host [String] host or IP for API
      # @param port [String, Fixnum] port for API
      def initialize(host, port)
        @host = host
        @port = port
      end

      # Make call to API and process response
      #
      # @param method [String] request method
      # @param args [Hash, Array, String] data sent as request
      # @return [Hash, Array, String] the data in the format received from server
      # @raise [Error::InvalidJSON] if data from server is not valid JSON
      def call(method, args)
        resp = send_single_request(method.to_s, args)

        begin
          data = MultiJson.decode(resp)
        rescue
          raise Error::InvalidJSON.new(resp)
        end

        return process_single_response(data)

      rescue Exception, StandardError => e
        e.extend(Error) unless e.is_a?(Error)
        raise e
      end

      # The method that does the actual sending of data to API
      #
      # @param method [String] request method
      # @param args [Hash, Array, String] data sent as request
      # @return [Hash] response from server in JSON format (Hash)
      # @raise [Error::InvalidResponse] on empty response from server, or no response
      def send_single_request(method, args)
        @request = MultiJson.encode({
                                        jsonrpc:  JSON_RPC_VERSION,
                                        method:   method,
                                        params:   args,
                                        id:       self.class.make_id
                                    })

        begin
          socket = TCPSocket.open(@host, @port)
          socket.write(@request)
          socket.close_write
          resp = socket.read
        ensure
          socket.close if socket
        end

        raise Error::InvalidResponse.new if resp.nil? || resp.empty?

        return @response = resp
      end

      # Process and validate response from API
      #
      # @param data [Hash] response from API
      # @return [Hash, Array, String] from result key in response
      # @raise [Error::InvalidResponse] if response does not validate
      # @raise [Error::ServerError] on response with error key
      def process_single_response(data)
        raise Error::InvalidResponse.new unless valid_response?(data)

        if !!data['error']
          code = data['error']['code']
          msg = data['error']['message']
          raise Error::ServerError.new(code, msg)
        end

        return data['result']
      end

      # Validates tje response from API
      #
      # @param data [Hash] response from API
      # @return [true, false] true if valid or false when invalid
      def valid_response?(data)
        return false unless data.is_a?(Hash)
        return false if data['jsonrpc'] != JSON_RPC_VERSION
        return false unless data.has_key?('id')
        return false if data.has_key?('error') && data.has_key?('result')

        if data.has_key?('error')
          if !data['error'].is_a?(Hash) || !data['error'].has_key?('code') || !data['error'].has_key?('message')
            return false
          end

          if !data['error']['code'].is_a?(Fixnum) || !data['error']['message'].is_a?(String)
            return false
          end
        end

        return true
      rescue
        return false
      end
    end
  end
end