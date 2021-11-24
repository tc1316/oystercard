require "journey"
require "oystercard"
require "journey_log"

describe Journey do
  let(:journey) { described_class.new }
  let(:entry_station) { "Aldgate East" } 
  let(:exit_station) { "Tower Hill" }
  let(:oystercard) { Oystercard.new(1)}
  
  it "can initialize a journey with an entry station when touching in" do
    oystercard.touch_in(entry_station)
    expect(oystercard.journey_log.journey.entry).to eq("Aldgate East")
  end

  # it "can finish a journey with an exit station" do 
  #   oystercard.touch_in(entry_station)
  #   oystercard.touch_out(exit_station)
  #   expect(oystercard.journey_log.journeys[0].exit).to eq("Tower Hill")    
  # end

  it "can calculate the default journey fare" do
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    expect(journey.read_fare).to be(1)
  end

  it "can penalize the fare of the journey if no entry station" do
    oystercard.touch_out(exit_station)
    expect(oystercard.journey_log.journeys[0].read_fare).to eq(6)
  end

  it "can penalize the fare of the journey if no exit station" do
    oystercard.touch_out(entry_station)
    expect(oystercard.journey_log.journeys[0].read_fare).to eq(6)
  end


  it "can return if a journey is complete or not" do
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    expect(oystercard.journey_log.journeys[0].complete?).to be_truthy
  end
  
end