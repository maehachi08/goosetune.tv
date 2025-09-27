require "test_helper"

class GenreTest < ActiveSupport::TestCase
  fixtures :genres

  test "should have valid fixtures" do
    assert_equal 8, Genre.count
    
    pops_genre = genres(:genre_1)
    assert_equal "ポップス", pops_genre.name
    assert_equal "ポップスミュージック", pops_genre.description
  end

  test "should find genre by name" do
    anime_genre = Genre.find_by(name: "アニメソング")
    assert_not_nil anime_genre
    assert_equal 5, anime_genre.id
  end
end