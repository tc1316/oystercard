require "journey"
require "oystercard"

describe Journey do
  let(:journey) { described_class.new(entry_station) }
  let(:entry_station) { "Aldgate East" } 
  let(:exit_station) { "Tower Hill" }
  let(:oystercard) { Oystercard.new(1)}
  
  it "can initialize a journey with an entry station" do
    expect(journey.entry).to eq("Aldgate East")
  end

  it "can finish a journey with an exit station" do 
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    expect(oystercard.journey.exit).to eq("Tower Hill")    
  end

  it "can calculate the default journey fare" do
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    expect(journey.fare).to be(1)
  end

  it "can calculate the penalty journey fare if no entry station" do
    oystercard.touch_out(exit_station)
    expect(journey.fare).to be(6)
  end

  it "can calculate the penalty journey fare if no exit station" do
    oystercard.touch_out(entry_station)
    expect(journey.fare).to be(6)
  end


  it "can return if a journey is complete or not" do
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    expect(journey.complete?).to be_truthy
  end
  
end