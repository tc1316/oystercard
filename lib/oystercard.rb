require 'journey_log'

class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  PREVIOUS_JOURNEY = -2

  attr_reader :balance, :journey

  def initialize(balance=0)
    @balance = balance
    @in_journey = false
    @journey = nil
  end

  def top_up(amount)
    raise "Cannot top up beyond #{Oystercard::MAX_BALANCE}" if full?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Balance below minimum of #{Oystercard::MIN_BALANCE}" unless min?
    @journey = Journey.new(entry_station)
    JourneyLog.start(entry_station)
    if in_journey == true 
      @journeys[PREVIOUS_JOURNEY].penalize
      deduct(@journeys[PREVIOUS_JOURNEY].penalize)
    end
    in_journey = true
  end

  def touch_out(exit_station)
    if @journey == nil
      @journey = Journey.new 

      @journeys << @journey #[entry=nil,exit=nil, fare = 1]

      @journeys.last.penalize #[entry=nil,exit=nil, fare = 6]

      deduct(@journeys.last.penalize)

      @journeys.last.assign_exit_station(exit_station) #[entry=entry_station,exit=exit_station, fare = 1 || 6]

    else
      deduct(@journeys.last.read_fare) #Oystercard @balance -= 1 
  
      @journeys.last.assign_exit_station(exit_station) #[entry=entry_station,exit=exit_station, fare = 1 || 6]
    
    end

    @in_journey = false
    # @journey = nil

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