class Oystercard
  MAX_BALANCE = 90
  attr_reader :balance

  def initialize(balance=0)
    @balance = balance
  end

  def top_up(amount)
    raise "Cannot top up beyond #{Oystercard::MAX_BALANCE}" if full?(amount)
    @balance += amount
  end

  def deduct(fare=3)
    @balance -= fare
  end
  
  private

  def full?(amount)
    balance + amount > MAX_BALANCE 
  end

end