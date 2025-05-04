class Ustream < ApplicationRecord
  # kaminari
  paginates_per 20

  # relation
  # belongs_to :UstreamMilestones
  has_many :youtubes

  # primary key
  # refs http://qiita.com/k-shogo/items/884498ad512c0e6eb303
  self.primary_key = :id

  #--------------------------------------------------------------------
  # メソッド名: update_view_counts
  #
  # 説明:
  #   - ustreamエントリの再生回数の更新処理
  #
  # 引数:
  #   なし
  #-------------------------------------------------------------------- 
  def self.update_view_counts
    view_counts = Ustream.get_view_counts

    view_counts.keys.each do |id|
      next unless Ustream.exists?(:id => id)
      entry = Ustream.find(id)
      entry.update_attributes(:view_counts => view_counts[id])
      entry.save!
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
  #   id    => Ustream動画のID
  #   entry => Ustream動画オブジェクト(ただしidは入っていない)
  #            Ustream.get_videosメソッドで取ってきたデータ構造
  #-------------------------------------------------------------------- 
  def self.add_entry(entry=nil)
    entry = Ustream.new(
      :id          => entry[:id],
      :title       => entry[:title],
      :url         => entry[:url],
      :thumbnail   => entry[:thumbnail],
      :published   => entry[:published],
      :view_counts => entry[:view_counts],
    )
    entry.save!
  end

  #--------------------------------------------------------------------
  # メソッド名: get_hoy_list
  #  # 説明:
  #   - HOY一覧情報を返す
  #
  # 引数:
  #--------------------------------------------------------------------
  def self.get_hoy_list
    hoy_ustreams = {}
    ( 2011..Date.today.year.to_i ).each do |year|
      unless ::Hoy.get_hoy_ustream( year.to_s ).blank?
        hoy_ustreams[ year ] = ::Hoy.get_hoy_ustream( year.to_s )
      end
    end
    hoy_ustreams
  end

end
