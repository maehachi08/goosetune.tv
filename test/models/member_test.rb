require "test_helper"

class MemberTest < ActiveSupport::TestCase
  fixtures :members

  test "should get all members" do
    members = Member.get_all
    assert_not_nil members
    assert members.is_a?(Array)
    assert_equal 12, members.size
  end

  test "should get specific members" do
    member_ids = [1, 2, 3]
    members = Member.get_members(member_ids)
    assert_equal 3, members.size
    assert_equal "d-iZe", members.first.name
  end

  test "should get unrefine members" do
    member_ids = [1, 2]
    unrefine_members = Member.get_unrefine_members(member_ids)
    assert_equal 10, unrefine_members.size
    refute unrefine_members.any? { |m| [1, 2].include?(m.id) }
  end

  test "should get youtubes with refine members" do
    refine_members = Member.limit(2)
    youtubes = Member.get_youtubes_with_refine_members(refine_members)
    assert_not_nil youtubes
    assert youtubes.is_a?(Array)
  end

  test "should get unit group id for members" do
    member_ids = [1, 2]
    unit_group_id = Member.get_unit_group_id(member_ids)
    assert unit_group_id.nil? || unit_group_id.is_a?(Integer)
  end
end