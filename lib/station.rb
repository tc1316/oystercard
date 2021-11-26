# frozen_string_literal: true

# Stores name and zone info to be used by Oystercard
class Station
  attr_reader :name, :zone

  def initialize(name = nil, zone = nil)
    @name = name
    @zone = zone
  end
end
