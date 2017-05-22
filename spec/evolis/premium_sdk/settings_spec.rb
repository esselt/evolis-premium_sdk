require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Settings do
    let(:resource) { Settings.new HOST, PORT }

    it '#new is class Print' do
      expect(resource).to be_kind_of(Settings)
    end

    # Don't know how to test with persistent sessions, will come back later
  end
end