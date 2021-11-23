class Journey
  FARE = 1

  def initialize(entry_station)
    @entry_station = entry_station
    @exit_station = nil
  end

  def end_journey(exit_station)
    @exit_station = exit_station
  end


  def entry
    "#{@entry_station}"
  end

  def exit
    "#{@exit_station}"
  end

  private  
  attr_reader :entry_station, :exit_station

  def deduct(fare=FARE)
    @balance -= fare
  end

end