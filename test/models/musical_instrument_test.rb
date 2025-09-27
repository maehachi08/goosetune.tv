require "test_helper"

class MusicalInstrumentTest < ActiveSupport::TestCase
  fixtures :musical_instruments

  test "should have valid associations" do
    instrument = MusicalInstrument.new
    assert_respond_to instrument, :youtubes
  end

  test "should create musical instrument with valid attributes" do
    instrument = MusicalInstrument.new(
      name: "Guitar",
      description: "String instrument"
    )
    
    assert instrument.valid?
    assert instrument.save
  end
end