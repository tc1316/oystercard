require_relative "./journey_log"

class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  PREVIOUS_JOURNEY = -2

  attr_reader :balance, :journey, :journey_log

  def initialize(balance=0)
    @balance = balance
    @in_journey = false
    @journey = nil
    @journey_log = JourneyLog.new
  end

  def top_up(amount)
    raise "Cannot top up beyond #{Oystercard::MAX_BALANCE}" if full?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Balance below minimum of #{Oystercard::MIN_BALANCE}" unless min?

    @journey_log.start(entry_station)

    if @in_journey == true 
      @journey_log.journeys[PREVIOUS_JOURNEY].penalize
      deduct(@journey_log.journeys[PREVIOUS_JOURNEY].penalize)
    end

    @in_journey = true
  end

  def touch_out(exit_station)

    @journey_log.finish(exit_station)
    if @journey_log.current_journey.entry == ""
      @journey_log.current_journey.penalize 
      deduct(@journey_log.current_journey.penalize)
    else
      deduct(@journey_log.current_journey.read_fare) 
    end

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