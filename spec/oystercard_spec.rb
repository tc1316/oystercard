require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }


  it "has default balance of 0" do
    expect(oystercard.balance).to be(0)
  end



end