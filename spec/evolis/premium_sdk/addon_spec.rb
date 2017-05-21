require 'spec_helper'

RSpec.describe Evolis::PremiumSdk::Addon do
  it 'new be Addon class' do
    expect(Evolis::PremiumSdk::Addon.new HOST, PORT).to be_kind_of(Evolis::PremiumSdk::Addon)
  end

  it 'run command and get ServerError' do
    addon = Evolis::PremiumSdk::Addon.new HOST, PORT
    expect{addon.launch'unknown_command.exe', 'hello'}.to raise_error(Evolis::PremiumSdk::Error::ServerError)
  end
end