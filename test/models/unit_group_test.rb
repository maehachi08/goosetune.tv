require "test_helper"

class UnitGroupTest < ActiveSupport::TestCase
  fixtures :unit_groups

  test "should have valid fixtures" do
    assert_equal 5, UnitGroup.count
    
    johnny_beans = unit_groups(:unit_group_1)
    assert_equal "Johnny Beans", johnny_beans.name
    assert_equal "ジョニービーンズ", johnny_beans.description
  end

  test "should find unit group by name" do
    unit = UnitGroup.find_by(name: "ユニット")
    assert_not_nil unit
    assert_equal 2, unit.id
    assert_equal "ジャパニーズユニット", unit.description
  end
end