require "test_helper"

class MusicalInstrumentPlayerTest < ActiveSupport::TestCase
  test "should inherit from ActiveRecord::Base" do
    player = MusicalInstrumentPlayer.new
    assert player.is_a?(ActiveRecord::Base)
  end

  test "should create musical instrument player" do
    player = MusicalInstrumentPlayer.new
    assert_not_nil player
  end
end