class Youtube < ActiveRecord::Base
  # kaminari
  paginates_per 10
  max_paginates_per 30
  offset 5

  # 中間テーブルの定義
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :members
  has_and_belongs_to_many :musical_instruments
  has_and_belongs_to_many :unit_groups
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :cds

  # Youtube : TodayYoutube = M : 1
  # belongs_to :today_youtubes

  has_one :youtube_channel

  # 主キー設定
  # refs http://qiita.com/k-shogo/items/884498ad512c0e6eb303
  self.primary_key = :id

  #--------------------------------------------------------------------
  # メソッド名: update_view_counts
  #
  # 説明:
  #   - 再生回数の更新
  #   - /admin/youtube/update_view_counts で実行される
  #
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.update_view_counts
    goosetune = Goosetune::Youtube::Video.new
    view_counts = goosetune.get_view_counts
    view_counts.keys.each do |id|
      next unless Youtube.exists?(:id => id)
      Youtube.find(id).update_attributes(:view_counts => view_counts[id])
    end
  end

  #--------------------------------------------------------------------
  # メソッド名: add_entry
  #
  # 説明:
  #   - youtubesテーブルに未登録の動画エントリーを登録する
  #   - /admin/youtube/update_check で実行される
  #
  # 引数:
  #   id    => YouTube動画のID
  #   entry => YouTube動画オブジェクト(ただしidは入っていない)
  #            Youtube.get_videosメソッドで取ってきたデータ構造
  #-------------------------------------------------------------------- 
  def self.add_entry(entry)
    youtube = Youtube.new(
      :id             => entry[:id],
      :title          => entry[:title],
      :original_title => entry[:original_title],
      :url            => entry[:url],
      :thumbnail      => entry[:thumbnail],
      :published      => entry[:published],
      :view_counts    => entry[:view_counts],
    )

    # update artists_youtubes HABTM
    artist = Artist.where( :name => entry[:original_artist] )
    youtube.artists << artist

    # Save of Youtube model object and artists_youtubes HABTM
    youtube.save!
  end

  #--------------------------------------------------------------------
  # メソッド名: new_arrival
  #
  # 説明:
  #   - 新着エントリーを返す
  #     - Time.now の月に公開された(published)動画を返す
  #     - Time.now の月に公開された(published)動画が無い場合は存在するまで月を遡る(last_month)
  #     - Time.now の月に公開された動画が5曲より少ない場合は前月からも取得する
  #   - ActiveSupportのdate操作メソッドを利用
  #     - http://guides.rubyonrails.org/active_support_core_extensions.html
  #     - at_beginning_of_month => 月初日を返す
  #     - at_end_of_month => 月末日を返す
  #     - last_month => 前月を返す
  #
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.new_arrival
    from = Time.now.at_beginning_of_month
    to = from.at_end_of_month

    until Youtube.where(:published => from...to).exists?
      from = from.last_month.at_beginning_of_month
      to = from.at_end_of_month
    end

    if Youtube.where(:published => from...to).size < 5
      from = from.last_month.at_beginning_of_month
    end

    Youtube.where(:published => from...to).order('published DESC')
  end

  #--------------------------------------------------------------------
  # メソッド名: get_random_one
  #
  # 説明:
  #   - ランダムにエントリーを1つ返す
  #
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.get_random_one
    return Youtube.limit(1).order("RAND()")
  end

  #--------------------------------------------------------------------
  # メソッド名: get_year
  #
  # 説明:
  #   - 年間カバー動画を返す
  #
  # 引数:
  #   - year => 対象の年
  #-------------------------------------------------------------------- 
  def self.get_year(year="#{Time.now.strftime("%Y")}")
    self.where(:published => "#{year}-01-01"..."#{year}-12-31").
         where("title like '%Cover%'").
         order('published ASC')
  end

  #--------------------------------------------------------------------
  # メソッド名: get_year_all
  #
  # 説明:
  #   - 年間動画を返す
  #
  # 引数:
  #   - year => 対象の年
  #-------------------------------------------------------------------- 
  def self.get_year_all(year="#{Time.now.strftime("%Y")}")
    self.where(:published => "#{year}-01-01"..."#{year}-12-31").
         order('published ASC')
  end

  #--------------------------------------------------------------------
  # メソッド名: release_at_year
  #
  # 説明:
  #   - 原曲のリリース年リストを返す
  #   - 全エントリのrelease_atを取得し重複排除
  # 
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.release_at_year
    _years = []
    _release_at_date = self.order(:release_at).pluck(:release_at).compact

    _release_at_date.each do |date|
      _years.push(date.year)
    end
    _years.sort.uniq
  end

  #--------------------------------------------------------------------
  # メソッド名: release_at_years
  #
  # 説明:
  #   - 原曲のリリース年代を返す
  #   - 全エントリのrelease_atを取得し、4桁目を0に置換して年代にし、重複排除
  # 
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.release_at_years
    years = [] 
    _release_at_date = self.order(:release_at).pluck(:release_at).compact

    _release_at_date.each do |date|
      years.push(date.year.to_s.gsub(/\d$/,'0'))
    end

    years.uniq
  end

  #--------------------------------------------------------------------
  # メソッド名: playyouhouse
  #
  # 説明:
  #   - タイトルが曲名ではなく'Play You. House'となっている動画を取得
  # 
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.playyouhouse
    self.where("title like '%" + 'Play You. House' + "%'").order('published ASC')
  end

  #--------------------------------------------------------------------
  # メソッド名: sing
  #
  # 説明:
  #   - すべてのSingを返す
  #   - _entriesはActiveRecord::Associations::CollectionProxy クラスでorderメソッドはない
  # 
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.sing
    _entries = Artist.new.youtubes

    # アーティストがGoosehouse か Play You. Houseの動画を抽出し、singに絞る
    # 159: Play You. House
    # 1  : Goosehouse
    _ids = [159,1]
    _ids.each do |id|
      _entries.concat( 
        Artist.find(id).youtubes.where("original_title like '%" + 'sing' + "%' or memo like '%" + 'sing' + "%'").
        where.not(:id => 'kuQO-48SXOg').where.not(:id => 'DcoBmvRTEZ4').where.not(:id => 'gS1QhVpSEds').order('published ASC')
      )
    end

    # _entries オブジェクトは ActiveRecord::Associations::CollectionProxy
    # array に変換して返す
    #  refs http://www.rubydoc.info/docs/rails/3.1.1/ActiveRecord/Associations/CollectionProxy#to_ary-instance_method
    _entries.to_a
  end

  #--------------------------------------------------------------------
  # メソッド名: cover
  #
  # 説明:
  #   - 年ごとのカバー動画を1つずつ返す
  # 
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.cover
    # Play You. House 結成が2010年
    to = Date.new( 2010,01,01).year

    # 現在の西暦年を取得
    now = Date.today.year

    entries = {}
    for _year in to..now do
      #entries[_year] = ::Youtube.get_year(_year).limit(1).order("RAND()").first
      if self.get_year(_year).exists?
        entries[_year] = self.get_year(_year).limit(1).order("RAND()").first
      end
    end

    entries
  end

end
