require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double("Aldgate East")}
  let(:exit_station) { double("Tower Hill")}
  let(:journey) { {entry_station: entry_station, exit_station: exit_station}}
  
  it "has default balance of 0" do
    expect(oystercard.balance).to be(0)
  end

  it "has a default empty list of journeys" do
    expect(oystercard.journeys).to be_empty
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
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.balance).to be(0)
    end
  end

  context "when touching in" do
    it "the card should be identified as undergoing a journey" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      expect(oystercard.in_journey?).to be_truthy
    end

    it "checks if card has at least minimum amount" do
      expect{ oystercard.touch_in(entry_station) }.to raise_error("Balance below minimum of #{Oystercard::MIN_BALANCE}")
    end

    it "creates a journey with the entry station" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      expect(oystercard.journey.entry).to eq("#{entry_station}")
    end
  end

  context "when touching out" do
    it "the card should be identified as no longer in a journey" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.in_journey?).to be_falsey
    end

    it "the card should deduct the minimum fare from balance" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Oystercard::MIN_BALANCE)
    end

    it "adds the exit station to the journey" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journey.exit).to eq("#{exit_station}")
    end
  end

  context "when completing a journey" do
    it "stores the journey information" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journeys).to include(oystercard.journey)
    end

    it "makes one journey when touching in and then touching out" do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journeys.length).to be(1)
    end
  end

  it "stores incomplete journeys" do
    oystercard.top_up(Journey::PENALTY_FARE)
    oystercard.touch_in(entry_station)
    expect(oystercard.journeys.length).to be(1)
  end

end