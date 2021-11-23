class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1

  attr_reader :balance, :journeys, :journey

  def initialize(balance=0)
    @balance = balance
    @in_journey = false
    @journeys = [] #Contains multiple journey objects
    @journey = nil
  end

  def top_up(amount)
    raise "Cannot top up beyond #{Oystercard::MAX_BALANCE}" if full?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Balance below minimum of #{Oystercard::MIN_BALANCE}" unless min?
    @journey = Journey.new
    @journey.penalize_on_touch_in if @in_journey == true
    @journey.assign_entry_station(entry_station)
    @in_journey = true
  end

  def touch_out(exit_station)
    if @journey == nil
      @journey = Journey.new 
      @journey.penalize_on_touch_out
      deduct(Journey::PENALTY_FARE)
    else
      deduct(Journey::DEFAULT_FARE)    
    end
    @journey.assign_exit_station(exit_station)
    @journeys << @journey
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

  private

  def full?(amount)
    balance + amount > MAX_BALANCE 
  end

  def min?
    balance >= MIN_BALANCE
  end

  def deduct(fare)
    @balance -= fare
  end

end