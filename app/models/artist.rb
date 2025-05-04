class Artist < ActiveRecord::Base
  # 中間テーブルの定義
  has_and_belongs_to_many :youtubes

  #--------------------------------------------------------------------
  # メソッド名: add
  #
  # 説明:
  #   - アーティスト名を登録する
  #
  # 引数:
  #   - artist_name => 登録アーティスト名
  #-------------------------------------------------------------------- 
  def self.add(artist_name=nil)
    artist = Artist.new( :name => artist_name )
    artist.save!
  end

  #--------------------------------------------------------------------
  # メソッド名: get_youtubes
  #
  # 説明:
  #   - アーティストに紐付くYoutubeエントリを配列で返す
  #   - array変数要素を降順ソートしてから返す
  #     - http://blog.livedoor.jp/maru_tak/archives/50687894.html
  #
  # 引数:
  #   - artist_ids => 対象artist_idの配列
  #-------------------------------------------------------------------- 
  def self.get_youtubes(artist_ids=nil)
    artists = Artist.find(artist_ids)

    array = []
    artists.each do |artist|
      artist.youtubes.order('published DESC').each do |entries|
        array << entries
      end
    end

    sorted_array = array.sort do |a,b|
      b.published <=> a.published
    end
    return sorted_array
  end
end
