require 'evolis/premium_sdk/version'
require 'evolis/premium_sdk/rpc_client'
require 'evolis/premium_sdk/addon'
require 'evolis/premium_sdk/cmd'
require 'evolis/premium_sdk/echo'
require 'evolis/premium_sdk/espf'
require 'evolis/premium_sdk/print'
require 'evolis/premium_sdk/sdk_base'
require 'evolis/premium_sdk/setting'
require 'evolis/premium_sdk/supervision'

module Evolis
  module PremiumSdk
    class Sdk

      # @return [Addon]
      attr_reader :addon

      # @return [Cmd]
      attr_reader :cmd

      # @return [Echo]
      attr_reader :echo

      # @return [Espf]
      attr_reader :espf

      # @return [Print]
      attr_reader :print

      # @return [Setting]
      attr_reader :setting

      # @return [Supervision]
      attr_reader :supervision

      # Initialize child classes so they can be used directly under a Evolis::PremiumSdk.new
      #
      # @param host [String] host or IP of SDK
      # @param port [String, Fixnum] port of SDK
      def initialize(host, port)
        @addon       = Addon.new host, port
        @cmd         = Cmd.new host, port
        @echo        = Echo.new host, port
        @espf        = Espf.new host, port
        @print       = Print.new host, port
        @setting     = Setting.new host, port
        @supervision = Supervision.new host, port
      end
    end
  end
end