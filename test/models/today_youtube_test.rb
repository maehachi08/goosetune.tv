require "test_helper"
require "minitest/mock"

class TodayYoutubeTest < ActiveSupport::TestCase
  fixtures :today_youtubes, :youtubes

  test "should add today youtube for current date when none exists" do
    # Use a specific date to avoid conflicts with other tests
    test_date = Date.new(2025, 1, 1)
    
    # Ensure we have youtube fixtures available
    assert Youtube.count > 0, "Youtube fixtures must be present for this test"
    
    # Clear any existing entry for this date
    TodayYoutube.where(date: test_date).destroy_all
    
    initial_count = TodayYoutube.count
    TodayYoutube.add(test_date)
    
    assert_equal initial_count + 1, TodayYoutube.count
    
    today_youtube = TodayYoutube.where(date: test_date).first
    assert_not_nil today_youtube
    assert_equal test_date, today_youtube.date
    assert_not_nil today_youtube.youtube_id
  end

  test "should not add duplicate today youtube for same date" do
    # Use a specific date to avoid conflicts
    test_date = Date.new(2025, 1, 2)
    
    # Clear any existing entry for this date
    TodayYoutube.where(date: test_date).destroy_all
    
    # Add first entry
    TodayYoutube.add(test_date)
    initial_count = TodayYoutube.count
    
    # Try to add again - should not create duplicate
    TodayYoutube.add(test_date)
    
    assert_equal initial_count, TodayYoutube.count
    assert_equal 1, TodayYoutube.where(date: test_date).count
  end

  test "should add today youtube for specific date" do
    specific_date = Date.new(2023, 6, 15)
    
    # Clear any existing entry for this date
    TodayYoutube.where(date: specific_date).destroy_all
    
    assert_difference('TodayYoutube.count', 1) do
      TodayYoutube.add(specific_date)
    end
    
    today_youtube = TodayYoutube.where(date: specific_date).first
    assert_not_nil today_youtube
    assert_equal specific_date, today_youtube.date
  end

  test "should handle string date parameter" do
    date_string = "2023-07-20"
    expected_date = Date.parse(date_string)
    
    # Clear any existing entry for this date
    TodayYoutube.where(date: expected_date).destroy_all
    
    assert_difference('TodayYoutube.count', 1) do
      TodayYoutube.add(date_string)
    end
    
    today_youtube = TodayYoutube.where(date: expected_date).first
    assert_not_nil today_youtube
    assert_equal expected_date, today_youtube.date
  end

  test "should get today youtube for existing date" do
    test_date = Date.new(2023, 8, 10)
    # Use existing fixture youtube ID
    test_youtube_id = "ZbhW_GDuk0c"
    
    # Clear any existing entry for this date
    TodayYoutube.where(date: test_date).destroy_all
    
    # Create a test entry
    TodayYoutube.create!(youtube_id: test_youtube_id, date: test_date)
    
    result = TodayYoutube.get_today(test_date)
    assert_not_nil result
    assert_equal test_youtube_id, result.id
  end

  test "should create and get today youtube for non-existing date" do
    test_date = Date.new(2023, 9, 15)
    
    # Clear any existing entry for this date
    TodayYoutube.where(date: test_date).destroy_all
    
    # Ensure we have youtube fixtures available
    assert Youtube.count > 0, "Youtube fixtures must be present for this test"
    
    initial_count = TodayYoutube.count
    result = TodayYoutube.get_today(test_date)
    
    assert_not_nil result
    assert_equal initial_count + 1, TodayYoutube.count
    assert TodayYoutube.where(date: test_date).exists?
  end

  test "should handle string date in get_today" do
    date_string = "2023-10-05"
    expected_date = Date.parse(date_string)
    
    # Clear any existing entry for this date
    TodayYoutube.where(date: expected_date).destroy_all
    
    # Ensure we have youtube fixtures available
    assert Youtube.count > 0, "Youtube fixtures must be present for this test"
    
    result = TodayYoutube.get_today(date_string)
    assert_not_nil result
    assert TodayYoutube.where(date: expected_date).exists?
  end
end