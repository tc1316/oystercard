require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

  it "has default balance of 0" do
    expect(oystercard.balance).to be(0)
  end

  context "when topping up" do 
    it "can be topped up" do
      oystercard.top_up(10)
      expect(oystercard.balance).to be(10)
    end
    it "cannot be topped up beyond max balance" do
      expect{oystercard.top_up(Oystercard::MAX_BALANCE+0.01)}.to raise_error("Cannot top up beyond #{Oystercard::MAX_BALANCE}")
    end

  context "when paying" do
    it "deducts fare from balance" do
      oystercard.deduct
      expect(oystercard.balance).to be(-3)
    end
  end
  end

end