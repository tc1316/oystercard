require 'journey_log'
require 'oystercard'
require 'journey'

describe JourneyLog do
  subject(:journey_log) { described_class.new(Journey) }
  let(:oystercard) { Oystercard.new(Oystercard::MAX_BALANCE) }
  let(:entry_station) { "Aldgate East" } 
  let(:exit_station) { "Tower Hill" }

  it 'starts a journey' do
    journey_log.start(entry_station)
    expect(journey_log.current_journey.entry).to eq("Aldgate East")
  end

  it 'ends a journey' do
    journey_log.finish(exit_station)
    expect(journey_log.current_journey.exit).to eq("Tower Hill")
  end

  it 'returns a list of journeys' do
    expect(journey_log.journeys).to be_empty
  end
end