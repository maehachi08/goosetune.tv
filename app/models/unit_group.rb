class UnitGroup < ApplicationRecord
  # 中間テーブルの定義
  has_and_belongs_to_many :youtubes
  has_and_belongs_to_many :members
end
