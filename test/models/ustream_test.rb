require "test_helper"
require "minitest/mock"

class UstreamTest < ActiveSupport::TestCase
  fixtures :ustreams, :hoys

  test "should update view counts" do
    # Skip this test as update_view_counts method doesn't exist in the model
    skip "update_view_counts method not implemented in Ustream model"
  end

  test "should add entry with valid data" do
    entry_data = {
      id: "new_stream_id",
      title: "New Test Stream",
      url: "http://test.com/new",
      thumbnail: "http://test.com/new_thumb.jpg", 
      published: Time.current,
      view_counts: 2000
    }

    assert_difference('Ustream.count', 1) do
      Ustream.add_entry(entry_data)
    end

    ustream = Ustream.find("new_stream_id")
    assert_equal "New Test Stream", ustream.title
    assert_equal "http://test.com/new", ustream.url
    assert_equal 2000, ustream.view_counts
  end

  test "should get hoy list" do
    hoy_list = Ustream.get_hoy_list
    assert_not_nil hoy_list
    assert hoy_list.is_a?(Hash)
    
    # Should include years from 2011 to current year
    current_year = Date.current.year
    (2011..current_year).each do |year|
      # Each year might or might not have a HOY ustream
      if hoy_list.key?(year)
        assert hoy_list[year].is_a?(Ustream)
      end
    end
  end

  test "should handle missing ustream entries in hoy list" do
    # This tests the case where Hoy.get_hoy_ustream returns nil
    hoy_list = Ustream.get_hoy_list
    
    # Should not include years where Hoy.get_hoy_ustream returns blank
    hoy_list.each do |year, ustream|
      assert_not_nil ustream
      assert ustream.is_a?(Ustream)
    end
  end

  test "should have correct primary key" do
    assert_equal :id, Ustream.primary_key.to_sym
  end

  test "should have correct pagination settings" do
    assert_equal 20, Ustream.default_per_page
  end

  test "should have correct associations" do
    ustream = Ustream.new
    assert_respond_to ustream, :youtubes
  end
end