class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  FARE = 1
  attr_reader :balance, :journeys, :entry_station, :exit_station

  def initialize(balance=0)
    @balance = balance
    @in_journey = false
    @journeys = [] #Contains multiple journey objects
  end

  def top_up(amount)
    raise "Cannot top up beyond #{Oystercard::MAX_BALANCE}" if full?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Balance below minimum of #{Oystercard::MIN_BALANCE}" unless min?
    @entry_station = entry_station #Extract
    @journeys <<  { entry_station: entry_station } #Extract
    @in_journey = true
  end

  def touch_out(exit_station)
    deduct(MIN_BALANCE)
    @in_journey = false
    @entry_station = nil #Extract
    @exit_station = exit_station #Extract
    @journeys[-1].merge!(exit_station: exit_station) #Extract
  end

  def in_journey?
    @entry_station
  end

  private

  def full?(amount)
    balance + amount > MAX_BALANCE 
  end

  def min?
    balance >= MIN_BALANCE
  end

  def deduct(fare=FARE)
    @balance -= fare
  end

end