# frozen_string_literal: true

require 'journey'

describe Journey do
  let(:journey) { described_class.new }
  let(:entry_station) { 'Aldgate East' }
  let(:exit_station) { 'Tower Hill' }
  let(:entry_zone) { 1 }
  let(:exit_zone) { 1 }

  # it "can initialize a journey with an entry station when touching in" do
  #   oystercard.touch_in(entry_station)
  #   expect(oystercard.journey_log.journey.entry).to eq(entry_station)
  # end

  # it "can finish a journey with an exit station" do
  #   oystercard.touch_in(entry_station)
  #   oystercard.touch_out(exit_station)
  #   expect(oystercard.journey_log.journeys[0].exit).to eq("Tower Hill")
  # end

  it 'is initialized with the default journey fare' do
    journey.assign_entry_station_and_zone(entry_station, entry_zone)
    journey.assign_exit_station_and_zone(exit_station, entry_zone)
    expect(journey.read_fare).to be(1)
  end

  it 'can return penalty journey fare' do
    expect(journey.calculate_fare).to be(6)
  end

  it 'can return if a journey is complete' do
    journey.assign_entry_station_and_zone(entry_station, entry_zone)
    journey.assign_exit_station_and_zone(exit_station, entry_zone)
    expect(journey.complete?).to be_truthy
  end

  it 'can return if a journey is incomplete' do
    journey.assign_entry_station_and_zone(entry_station, entry_zone)
    expect(journey.complete?).to be_falsey
  end
end
