require_relative "./journey"

class JourneyLog

  attr_reader :journeys, :journey

  def initialize(journey_class = Journey)
    @journeys = []
    @journey_class = journey_class
  end

  def start(entry_station)
    @journey = @journey_class.new
    @journey.assign_entry_station(entry_station)
    @journeys << @journey
  end

  def finish(exit_station)
    if @journey
      @journey.assign_exit_station(exit_station)
    else
      @journey = @journey_class.new
      @journey.assign_exit_station(exit_station)
      @journeys << @journey
    end
  end
end