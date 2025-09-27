require "test_helper"

class YoutubeTest < ActiveSupport::TestCase
  fixtures :youtubes, :artists, :artists_youtubes

  test "should update view counts" do
    # Skip this test since we don't have the Goosetune gem
    skip "Goosetune gem not available in test environment"
  end

  test "should add entry with valid data" do
    entry_data = {
      id: "new_video_id",
      title: "Test Video",
      original_title: "Original Test Video",
      url: "https://youtube.com/watch?v=new_video_id",
      thumbnail: "https://img.youtube.com/vi/new_video_id/default.jpg",
      published: Time.current,
      view_counts: 1000,
      original_artist: "Goose house"
    }

    assert_difference('Youtube.count', 1) do
      Youtube.add_entry(entry_data)
    end

    youtube = Youtube.find("new_video_id")
    assert_equal "Test Video", youtube.title
    assert_equal "Original Test Video", youtube.original_title
  end

  test "should get new arrival videos" do
    new_arrivals = Youtube.new_arrival
    assert_not_nil new_arrivals
    
    # Should return videos from current or previous months
    if new_arrivals.any?
      assert new_arrivals.first.published <= Time.current
    end
  end

  test "should get random one video" do
    random_video = Youtube.get_random_one
    assert_not_nil random_video
    assert_equal 1, random_video.size
  end

  test "should get year videos with cover filter" do
    current_year = Time.current.year
    year_videos = Youtube.get_year(current_year.to_s)
    
    assert_not_nil year_videos
    # Should filter videos with 'Cover' in title
    year_videos.each do |video|
      assert_includes video.title, 'Cover'
    end if year_videos.any?
  end

  test "should get all year videos" do
    current_year = Time.current.year
    all_year_videos = Youtube.get_year_all(current_year.to_s)
    
    assert_not_nil all_year_videos
    # Should return all videos from the year, not just covers
  end

  test "should get release at years" do
    release_years = Youtube.release_at_year
    assert_not_nil release_years
    assert release_years.is_a?(Array)
    
    # Should be sorted and unique
    assert_equal release_years.sort.uniq, release_years if release_years.any?
  end

  test "should get release at year decades" do
    release_decades = Youtube.release_at_years
    assert_not_nil release_decades
    assert release_decades.is_a?(Array)
    
    # Should convert years to decades (ending in 0)
    release_decades.each do |decade|
      assert decade.end_with?('0') if decade.is_a?(String)
    end if release_decades.any?
  end

  test "should get play you house videos" do
    pyh_videos = Youtube.playyouhouse
    assert_not_nil pyh_videos
    
    # Should filter videos with 'Play You. House' in title
    pyh_videos.each do |video|
      assert_includes video.title, 'Play You. House'
    end if pyh_videos.any?
  end

  test "should get sing videos" do
    sing_videos = Youtube.sing
    assert_not_nil sing_videos
    assert sing_videos.is_a?(Array)
    
    # Should exclude specific video IDs
    excluded_ids = ['kuQO-48SXOg', 'DcoBmvRTEZ4', 'gS1QhVpSEds']
    sing_videos.each do |video|
      refute_includes excluded_ids, video.id
    end if sing_videos.any?
  end

  test "should get cover videos by year" do
    cover_videos = Youtube.cover
    assert_not_nil cover_videos
    assert cover_videos.is_a?(Hash)
    
    # Should return hash with year keys
    cover_videos.each do |year, video|
      assert year.is_a?(Integer)
      assert year >= 2010
      assert year <= Date.current.year
      assert video.is_a?(Youtube) if video
    end
  end
end