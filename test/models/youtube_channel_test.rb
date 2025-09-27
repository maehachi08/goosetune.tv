require "test_helper"

class YoutubeChannelTest < ActiveSupport::TestCase
  test "should have many youtubes" do
    channel = YoutubeChannel.new
    assert_respond_to channel, :youtubes
  end

  test "should create youtube channel with valid attributes" do
    channel = YoutubeChannel.new(
      youtube_channel_id: "UC_test_channel_id",
      name: "Test Channel"
    )
    
    assert channel.valid?
    assert channel.save
  end
end