# frozen_string_literal: true

require 'journey_log'

describe JourneyLog do
  subject(:journey_log) { described_class.new(Journey) }
  let(:entry_station) { 'Aldgate East' }
  let(:exit_station) { 'Tower Hill' }
  let(:entry_zone) { 1 }
  let(:exit_zone) { 2 }

  it 'starts a journey' do
    journey_log.start(entry_station, entry_zone)
    expect(journey_log.journeys).not_to be_empty
  end

  it 'ends a journey' do
    2.times { journey_log.finish(exit_station, exit_zone) }
    expect(journey_log.journeys.length).to eq(2)
  end

  it 'returns a list of journeys' do
    5.times do
      journey_log.start(entry_station, entry_zone)
      journey_log.finish(exit_station, exit_zone)
    end
    expect(journey_log.journeys.length).to eq(5)
  end

  # it "returns existing journey if one already exists" do
  #   i = journey_log
  #   i.start(entry_station)
  #   i.finish(exit_station)
  #   expect(journey_log.journeys).to eq(i.journeys)
  # end
end
