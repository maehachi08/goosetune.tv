class Hoy < ApplicationRecord
  # validation check
  validates :year, presence: true,
                   length: { is: 4 },
                   inclusion: { in: 2010..Date.today.year },
                   format: { with: /(19|20)\d{2}/i }

  #--------------------------------------------------------------------
  # メソッド名: all_entries
  #
  # 説明:
  #   - 全年ごとのHOYエントリを返す
  #
  # 引数: なし
  #-------------------------------------------------------------------- 
  def self.all_entries()
    years_list = self.all.pluck(:year)
    _years = years_list.uniq!
    years = _years.sort
    all_entries = {}
    entries = []

    years.each do |year|
      self.where(:year => year).order('ranking ASC').pluck(:youtube_id).each do |id|
        entries << ::Youtube.find(id)
      end

      all_entries[year] = entries
    end

    return all_entries
  end

  #--------------------------------------------------------------------
  # メソッド名: year
  #
  # 説明:
  #   - 引数で受け取った年のHOYエントリを返す
  #
  # 引数:
  #   - year => 取得対象の年
  #-------------------------------------------------------------------- 
  def self.year(year=nil)
    entries = []
    self.where(:year => year).order('ranking ASC').pluck(:youtube_id).each do |id|
      entries << ::Youtube.find(id)
    end
    return entries
  end

  #--------------------------------------------------------------------
  # メソッド名: hoy?
  #
  # 説明:
  #   - 引数で受け取ったustream_idがHOYかどうか返す
  #
  # 引数:
  #   - ustream_id => チェック対象ustream_id
  #-------------------------------------------------------------------- 
  def self.hoy?(ustream_id=nil)
    case ustream_id
      when '98294040' then
        return true
      when '80460063' then
        return true
      when '56683384' then
        return true
      when '41941980' then
        return true
      when '27732716' then
        return true
      when '19048707' then
        return true
      else
        return false
    end
  end

  #--------------------------------------------------------------------
  # メソッド名: get_hoy_ustream
  #
  # 説明:
  #   - 引数で受け取った年のHouse Of the Year(HOY)のUstreamエントリを返す
  #
  # 引数:
  #   - year => 対象年
  #-------------------------------------------------------------------- 
  def self.get_hoy_ustream(year=nil)
    case year
      when '2016' then
        return ::Ustream.find('98294040')
      when '2015' then
        return ::Ustream.find('80460063')
      when '2014' then
        return ::Ustream.find('56683384')
      when '2013' then
        return ::Ustream.find('41941980')
      when '2012' then
        return ::Ustream.find('27732716')
      when '2011' then
        return ::Ustream.find('19048707')
    end
  end

  #--------------------------------------------------------------------
  # メソッド名: get_year
  #
  # 説明:
  #   - 引数で受け取った年のHOY放送の年を返す
  #
  # 引数:
  #   - ustream_id
  #-------------------------------------------------------------------- 
  def self.get_year(ustream_id=nil)
    case ustream_id
      when '19048707' then
        return '2011'
      when '27732716' then
        return '2012'
      when '41941980' then
        return '2013'
      when '56683384' then
        return '2014'
      when '80460063' then
        return '2015'
      when '98294040' then
        return '2016'
      else
        return nil
    end
  end
end
