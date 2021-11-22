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
  end

  context "when paying" do
    it "deducts fare from balance" do
      oystercard.touch_out
      expect(oystercard.balance).to be(-Oystercard::FARE)
    end
  end

  context "when touching in" do
    it "the card should be identified as undergoing a journey" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in
      expect(oystercard.in_journey?).to be_truthy
    end

    it "checks if card has at least minimum amount" do
      expect{ oystercard.touch_in }.to raise_error("Balance below minimum of #{Oystercard::MIN_BALANCE}")
    end
  end

  context "when touching out" do
    it "the card should be identified as no longer in a journey" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in
      oystercard.touch_out
      expect(oystercard.in_journey?).to be_falsey
    end

    it "the card should deduct the minimum fare from balance" do
      expect{oystercard.touch_out}.to change{oystercard.balance}.by(-Oystercard::MIN_BALANCE)
    end

  end
end