require "test_helper"

class UstreamMilestoneTest < ActiveSupport::TestCase
  fixtures :ustreams
  
  test "should belong to ustream" do
    milestone = UstreamMilestone.new
    assert_respond_to milestone, :ustream
  end

  test "should create ustream milestone with valid attributes" do
    milestone = UstreamMilestone.new(
      name: "Test Milestone",
      description: "A test milestone",
      ustream_id: "100383207"  # Use existing fixture ustream ID
    )
    
    assert milestone.valid?
  end
end