class TodayYoutube < ApplicationRecord
  # Entry : TodayYoutube = M : 1
  has_many :youtubes

  #--------------------------------------------------------------------
  # メソッド名: add
  #
  # 説明:
  #   - 今日のGoosehouse登録処理
  #
  # 引数:
  #   なし
  #--------------------------------------------------------------------
  def self.add(date=nil)
    today = ''

    if date.nil?
      today = Date.today
    else
      today = Date.parse(date.to_s)
    end

    unless TodayYoutube.where(date: today).exists? then
      entry = Youtube.limit(1).order("RAND()")

      entry.each do |c|
        id = c.id
        today = ::TodayYoutube.new(:youtube_id => id,:date => today)
        today.save!
      end
    end
  end

  #--------------------------------------------------------------------
  # メソッド名: get_today
  #
  # 説明:
  #   - 今日のGoosehouseエントリ取得
  #     - 引数で与えるdate を変更すれば該当日付のエントリーを返す
  #     - 引数で与えるdateオブジェクトの日付のエントリーがない場合はその時点での最新エントリーを返す
  #
  # 引数:
  #   date_string => 対象日
  #-------------------------------------------------------------------- 
  def self.get_today(date_string)
    entry = nil
    date = Date.parse(date_string.to_s)

    unless TodayYoutube.where(date: date).exists?
      self.add(date)
    end

    entry = TodayYoutube.where(date: date)
    return Youtube.find(entry.first.youtube_id.to_s)
  end
end
