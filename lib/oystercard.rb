# frozen_string_literal: true

require_relative './journey_log'
require_relative './station'

# Stores balance, state of journey and initializes a JourneyLog object which itself contains Journey objects
class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  PREVIOUS_JOURNEY = -2 # 2nd last element in journeys array
  CURRENT_JOURNEY = -1 # Last element in journeys array

  attr_reader :balance, :journey_log

  def initialize(balance = 0)
    @balance = balance
    @in_journey = false
    @journey_log = JourneyLog.new
  end

  def top_up(amount)
    raise "Cannot top up beyond #{Oystercard::MAX_BALANCE}" if full?(amount)
    @balance += amount
  end

  def touch_in(station)
    raise "Balance below minimum of #{Oystercard::MIN_BALANCE}" unless min?
    entry_station = station.name 
    entry_zone = station.zone

    @journey_log.start(entry_station, entry_zone)
    if @in_journey == true
      @journey_log.journeys[PREVIOUS_JOURNEY].calculate_fare
      deduct(@journey_log.journeys[PREVIOUS_JOURNEY].read_fare)
    end
    @in_journey = true
  end

  def touch_out(station)
    exit_station = station.name 
    exit_zone = station.zone
    if @in_journey == false
      @journey_log.start(nil)
      @journey_log.journey.calculate_fare
    end
    @journey_log.finish(exit_station, exit_zone)
    deduct(@journey_log.journeys[CURRENT_JOURNEY].read_fare)
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

  private

  def full?(amount)
    @balance + amount > MAX_BALANCE
  end

  def min?
    @balance >= MIN_BALANCE
  end

  def deduct(fare)
    @balance -= fare
  end
end
