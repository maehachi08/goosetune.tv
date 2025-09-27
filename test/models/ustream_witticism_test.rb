require "test_helper"

class UstreamWitticismTest < ActiveSupport::TestCase
  fixtures :ustreams
  
  test "should belong to ustream" do
    witticism = UstreamWitticism.new
    assert_respond_to witticism, :ustream
  end

  test "should create ustream witticism with valid attributes" do
    witticism = UstreamWitticism.new(
      title: "Test Witticism",
      description: "A funny moment",
      ustream_id: "100383207",  # Use existing fixture ustream ID
      play_time: Time.current
    )
    
    assert witticism.valid?
  end
end