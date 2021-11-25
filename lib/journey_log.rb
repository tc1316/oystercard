require_relative "./journey"

class JourneyLog

  attr_reader :journey

  def initialize(journey_class = Journey)
    @journeys = []
    @journey_class = journey_class
  end
 
  def start(entry_station)
    current_journey
    if @journeys.include?(@journey)
      @journey = @journey_class.new
    end
    @journey.assign_entry_station(entry_station)
    @journeys << @journey
  end

  def finish(exit_station)
    current_journey
    unless @journeys.include?(@journey)
      @journeys << @journey
    end
    @journey.assign_exit_station(exit_station)
    @journey = nil
  end

  def journeys
    @journeys.dup
  end

  private

  def current_journey
    @journey ||= @journey_class.new
  end

end