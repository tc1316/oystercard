require_relative "./journey"

class JourneyLog

  attr_reader :journey

  def initialize(journey_class = Journey)
    @journeys = []
    @journey_class = journey_class
  end
 
  def start(entry_station=nil, entry_zone=nil)
    current_journey
    @journey = @journey_class.new if @journeys.include?(@journey)
    @journey.assign_entry_station_and_zone(entry_station, entry_zone)
    @journeys << @journey
  end


  def finish(exit_station=nil, exit_zone=nil)
    current_journey
    @journeys << @journey unless @journeys.include?(@journey)
    @journey.assign_exit_station_and_zone(exit_station, exit_zone)
    @journey.calculate_fare
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