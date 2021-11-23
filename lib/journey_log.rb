require 'journey'

class JourneyLog

  attr_reader :journeys, :journey

  def initialize(journey_class = Journey)
    @journeys = []
    @journey = journey_class.new
  end

  def start(entry_station)
    @journey.assign_entry_station(entry_station)
    # @journeys << @journey_class.journey
  end

  def finish(exit_station)
    @journey.assign_exit_station(exit_station)
  end
end