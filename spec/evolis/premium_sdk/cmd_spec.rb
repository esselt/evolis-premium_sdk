require 'spec_helper'

RSpec.describe Evolis::PremiumSdk::Cmd do
  it 'new be Cmd class' do
    expect(Evolis::PremiumSdk::Cmd.new HOST, PORT).to be_kind_of(Evolis::PremiumSdk::Cmd)
  end

  it 'send command and get response' do
    cmd = Evolis::PremiumSdk::Cmd.new HOST, PORT
    expect(cmd.send_command DEVICE, 'Rfv').to be_kind_of(String)
    expect(cmd.send_command DEVICE, '__ERROR__').to eq('ERROR CDE')
    expect{cmd.send_command '__ERROR__', 'Rfv'}.to raise_error(Evolis::PremiumSdk::Error::ServerError)
  end

  it 'get status and get response' do
    cmd = Evolis::PremiumSdk::Cmd.new HOST, PORT
    expect(cmd.get_status DEVICE).to be_kind_of(String)
    expect{cmd.get_status '__ERROR__'}.to raise_error(Evolis::PremiumSdk::Error::ServerError)
  end

  it 'reset communication and get true' do
    cmd = Evolis::PremiumSdk::Cmd.new HOST, PORT
    expect(cmd.reset_com DEVICE).to be true
    expect{cmd.reset_com '__ERROR__'}.to raise_error(Evolis::PremiumSdk::Error::ServerError)
  end
end