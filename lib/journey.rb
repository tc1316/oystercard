class Journey
  DEFAULT_FARE = 1
  PENALTY_FARE = 6
  ZONE_CROSSING_FARE = 1

  def initialize
    @entry_station = nil
    @exit_station = nil
    @entry_zone = nil
    @exit_zone = nil
    @fare = DEFAULT_FARE
  end

  def assign_entry_station_and_zone(entry_station, entry_zone)
    @entry_station, @entry_zone = entry_station, entry_zone
  end

  def assign_exit_station_and_zone(exit_station, exit_zone)
    @exit_station, @exit_zone = exit_station, exit_zone
  end

  def calculate_fare
    if complete?
      zones_crossed = (@entry_zone - @exit_zone).abs
      @fare = DEFAULT_FARE + (ZONE_CROSSING_FARE * zones_crossed)
    else 
      @fare = PENALTY_FARE
    end
  end

  def read_fare
    "#{@fare}".to_i 
  end
      
  def entry
    "#{@entry_station}"
  end

  def exit
    "#{@exit_station}"
  end
 
  def complete?
    return true if @entry_station && @exit_station
  end

end