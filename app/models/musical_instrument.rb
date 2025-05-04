class MusicalInstrument < ApplicationRecord
  # 中間テーブル
  has_and_belongs_to_many :youtubes
end
