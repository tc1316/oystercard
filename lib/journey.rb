class Journey
  DEFAULT_FARE = 1
  PENALTY_FARE = 6

  def initialize
    @entry_station = nil
    @exit_station = nil
    @fare = DEFAULT_FARE
  end

  def assign_entry_station(entry_station)
    @entry_station = entry_station
  end

  def assign_exit_station(exit_station)
    @exit_station = exit_station
  end

  def penalize
    @fare = PENALTY_FARE
    @fare
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

  private  
  attr_reader :entry_station, :exit_station, :fare

end