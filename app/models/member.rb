class Member < ApplicationRecord
  # 中間テーブルの定義
  has_and_belongs_to_many :youtubes
  has_and_belongs_to_many :unit_groups

  # 全メンバーを返す
  def self.get_all
    Rails.cache.fetch("members_get_all") do
      Member.all.to_a
    end
  end

  # 指定したmembers recordを返す
  # @param [Array] member_ids 絞り込み検索対象のmember_ids
  def self.get_members(member_ids=nil)
    Rails.cache.fetch("members_get_members_find_#{member_ids.join('_')}") do
      Member.find(member_ids)
    end
  end

  # 指定されていないmembers recordを返す
  # @param [Array] member_ids 絞り込み検索対象のmember_ids
  def self.get_unrefine_members(member_ids=nil)
    Rails.cache.fetch("members_get_unrefine_members_#{member_ids.join('_')}") do
      Member.where.not(id: member_ids).to_a
    end
  end

  # 引数で受け取ったmember_ids配列のメンバーのみが出演する動画だけを返す
  # @param [Array] member_ids 絞り込み検索対象のmember_ids
  def self.get_youtubes_with_refine_members(refine_members)
    entries = []
    Rails.cache.fetch("members_get_youtubes_refine_to_members_find_#{refine_members}") do
      Youtube.order('published DESC').each do |entry|
        if entry.members == refine_members
          entries.push(entry)
        end
      end
      entries
    end
  end

  # member_ids に該当するUnitGroupIdを返す
  # 該当しない場合は nil を返す
  # @param [Array] member_ids 絞り込み検索対象のmember_ids
  def self.get_unit_group_id(member_ids=nil)
    joined_unit_group_ids = []
    k = Hash.new(0)
    unit_group_id = nil

    members = Member.find(member_ids)
    members.each do |member|
      joined_unit_group_ids.concat(member.unit_group_ids)
    end
    joined_unit_group_ids.each{|x| k[x] += 1 }
    k.each do |k,v|
      if v == members.size
        unit_group_id = k
        break
      end
    end
    unit_group_id
  end
end
