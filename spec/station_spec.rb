# frozen_string_literal: true

require 'station'

describe Station do
  let(:station) { described_class.new('Aldgate East', 1) }

  it 'has a name' do
    expect(station.name).to eq('Aldgate East')
  end

  it 'has a zone' do
    expect(station.zone).to be(1)
  end
end
