require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe Supervision do
    let(:resource) { Supervision.new HOST, PORT }

    it '#new is class Print' do
      expect(resource).to be_kind_of(Supervision)
    end

    # Don't know how to test with persistent sessions, will come back later
  end
end