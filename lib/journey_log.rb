require_relative "./journey"

class JourneyLog

  attr_reader :journeys, :current_journey

  def initialize(journey_class = Journey)
    @journeys = []
    @journey_class = journey_class
    @current_journey = nil
  end
 
  def start(entry_station)
    fetch_current_journey
    @current_journey.assign_entry_station(entry_station)
    @journeys << @current_journey
  end

  def finish(exit_station)
    if @current_journey
      @current_journey.assign_exit_station(exit_station)
    else
      fetch_current_journey
      @current_journey.assign_exit_station(exit_station)
      @journeys << @current_journey
    end
  end

  private

  def fetch_current_journey
    if @current_journey == nil
      @current_journey = @journey_class.new
    elsif @current_journey.entry == "" || @current_journey.exit == ""
      @current_journey
      @current_journey = @journey_class.new
    end
  end

end