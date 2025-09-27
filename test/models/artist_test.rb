require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  fixtures :artists

  test "should create artist with valid name" do
    artist_name = "Test Artist"
    
    assert_difference('Artist.count', 1) do
      Artist.add(artist_name)
    end
    
    artist = Artist.last
    assert_equal artist_name, artist.name
  end

  test "should get youtubes for given artist ids" do
    artist_ids = [1, 2]
    youtubes = Artist.get_youtubes(artist_ids)
    
    assert_not_nil youtubes
    assert youtubes.is_a?(Array)
  end

  test "should handle non-existent artist ids" do
    artist_ids = [99999]
    assert_raises(ActiveRecord::RecordNotFound) do
      Artist.get_youtubes(artist_ids)
    end
  end
end