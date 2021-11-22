require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }


  it "has default balance of 0" do
    expect(oystercard.balance).to be(0)
  end

  it "can be topped up" do
    oystercard.top_up(10)
    expect(oystercard.balance).to be(10)
  end



end