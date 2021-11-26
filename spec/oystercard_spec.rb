# frozen_string_literal: true

require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:station1) { double(name: 'Aldgate East', zone: 1) }
  let(:station2) { double(name: 'Tower Hill', zone: 1) }

  context 'initializes' do
    it 'with a default balance of 0' do
      expect(oystercard.balance).to be(0)
    end

    it 'with a default empty list of journeys' do
      expect(oystercard.journey_log.journeys).to be_empty
    end
  end

  context 'when topping up' do
    it 'can be topped up' do
      oystercard.top_up(10)
      expect(oystercard.balance).to be(10)
    end
    it 'cannot be topped up beyond max balance' do
      expect do
        oystercard.top_up(Oystercard::MAX_BALANCE + 0.01)
      end.to raise_error("Cannot top up beyond #{Oystercard::MAX_BALANCE}")
    end
  end

  context 'when paying' do
    it 'deducts fare from balance' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(station1)
      oystercard.touch_out(station2)
      expect(oystercard.balance).to be(0)
    end
  end

  context 'when touching in' do
    it 'the card should be identified as undergoing a journey' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(station1)
      expect(oystercard.in_journey?).to be_truthy
    end

    it 'checks if card has at least minimum amount' do
      expect do
        oystercard.touch_in(station1)
      end.to raise_error("Balance below minimum of #{Oystercard::MIN_BALANCE}")
    end

    it 'creates a journey' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(station1)
      expect(oystercard.journey_log.journeys.length).to eq(1)
    end
  end

  context 'when touching out' do
    it 'the card should be identified as no longer in a journey' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(station1)
      oystercard.touch_out(station2)
      expect(oystercard.in_journey?).to be_falsey
    end

    it 'the card should deduct the minimum fare from balance' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(station1)
      expect { oystercard.touch_out(station2) }.to change {
                                                     oystercard.balance
                                                   }.by(-Oystercard::MIN_BALANCE)
    end
  end
  #   it 'adds the exit station to the journey' do
  #     oystercard.top_up(Oystercard::MIN_BALANCE)
  #     oystercard.touch_in(station1)
  #     oystercard.touch_out(station2)
  #     allow(station2).to receive(:exit).and_return(1)
  #     expect(oystercard.journey_log.journeys.exit).to include(station2)
  #   end
  # end
  # Move above to journeylog

  context 'when completing a journey' do
    it 'stores the journey information' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(station1)
      oystercard.touch_out(station2)
      expect(oystercard.journey_log.journeys).not_to be_empty
    end

    it 'makes one journey when touching in and then touching out' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(station1)
      oystercard.touch_out(station2)
      expect(oystercard.journey_log.journeys.length).to be(1)
    end
  end

  it 'stores incomplete journeys' do
    oystercard.top_up(Journey::PENALTY_FARE)
    oystercard.touch_in(station1)
    expect(oystercard.journey_log.journeys.length).to be(1)
  end

  it 'penalizes touching in twice in a row without touching out' do
    oystercard.top_up(Journey::PENALTY_FARE * 2)
    oystercard.touch_in(station1)
    oystercard.touch_in(station1)
    oystercard.touch_out(station2)
    expect(oystercard.balance).to eq(Journey::PENALTY_FARE * 2 - Journey::PENALTY_FARE - Journey::DEFAULT_FARE)
  end

  it 'penalizes touching out twice in a row without touching in' do
    oystercard.top_up(Journey::PENALTY_FARE * 2)
    oystercard.touch_in(station1)
    oystercard.touch_out(station2)
    oystercard.touch_out(station2)
    expect(oystercard.balance).to eq(Journey::PENALTY_FARE * 2 - Journey::PENALTY_FARE - Journey::DEFAULT_FARE)
  end
end
