require 'spec_helper'

RSpec.describe Evolis::PremiumSdk::Echo do
  it 'new be Cmd class' do
    expect(Evolis::PremiumSdk::Echo.new HOST, PORT).to be_kind_of(Evolis::PremiumSdk::Echo)
  end

  it 'send echo and get response' do
    echo = Evolis::PremiumSdk::Echo.new HOST, PORT

    msg = 'Small talk'
    expect(echo.echo msg).to eq(msg)
    expect(echo.echo '').to eq('')
  end
end