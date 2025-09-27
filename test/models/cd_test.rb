require "test_helper"

class CdTest < ActiveSupport::TestCase
  fixtures :cds

  test "should have valid associations" do
    cd = Cd.new
    assert_respond_to cd, :youtubes
  end

  test "should create cd with valid attributes" do
    cd = Cd.new(
      title: "Test Album",
      release_at: Date.current,
      url: "http://example.com/album"
    )
    
    assert cd.valid?
    assert cd.save
  end
end