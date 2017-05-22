require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Print do
    let(:resource) { Print.new HOST, PORT }

    it '#new is class Print' do
      expect(resource).to be_kind_of(Print)
    end

    # Don't know how to test with persistent sessions, will come back later
  end
end