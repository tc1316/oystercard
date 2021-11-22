class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  attr_reader :balance, :in_journey

  def initialize(balance=0)
    @balance = balance
    @in_journey = false
  end

  def top_up(amount)
    raise "Cannot top up beyond #{Oystercard::MAX_BALANCE}" if full?(amount)
    @balance += amount
  end

  def deduct(fare=3)
    @balance -= fare
  end

  def touch_in
    raise "Balance below minimum of #{Oystercard::MIN_BALANCE}" unless min?
    @in_journey = true
  end

  def touch_out
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
end