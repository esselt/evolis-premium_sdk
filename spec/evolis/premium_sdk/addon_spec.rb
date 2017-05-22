require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Addon do
    let(:resource) { Addon.new HOST, PORT }

    it '#new' do
      expect(resource).to be_kind_of(Addon)
    end

    it '#launch unknown command raise ServerError' do
      expect{resource.launch'unknown_command.exe', 'hello'}.to raise_error(Error::ServerError)
    end
  end
end