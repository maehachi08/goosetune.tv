# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2019_09_15_023023) do
  create_table "artists", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "reading"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "artists_youtubes", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id"
    t.integer "artist_id"
  end

  create_table "cds", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.date "release_at"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "url"
  end

  create_table "cds_youtubes", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id", null: false
    t.integer "cd_id", null: false
    t.index ["cd_id"], name: "index_cds_youtubes_on_cd_id"
    t.index ["youtube_id"], name: "index_cds_youtubes_on_youtube_id"
  end

  create_table "genres", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "genres_youtubes", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id", null: false
    t.integer "genre_id", null: false
    t.index ["genre_id"], name: "index_genres_youtubes_on_genre_id"
    t.index ["youtube_id"], name: "index_genres_youtubes_on_youtube_id"
  end

  create_table "hoys", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "year"
    t.integer "ranking", limit: 3
    t.string "youtube_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "members", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "members_unit_groups", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "unit_group_id", null: false
    t.index ["member_id"], name: "index_members_unit_groups_on_member_id"
    t.index ["unit_group_id"], name: "index_members_unit_groups_on_unit_group_id"
  end

  create_table "members_youtubes", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id"
    t.integer "member_id"
  end

  create_table "musical_instrument_players", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id", null: false
    t.integer "musical_instrument_id", null: false
    t.integer "member_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "musical_instruments", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "musical_instruments_youtubes", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id", null: false
    t.integer "musical_instrument_id", null: false
    t.index ["musical_instrument_id"], name: "index_musical_instruments_youtubes_on_musical_instrument_id"
    t.index ["youtube_id"], name: "index_musical_instruments_youtubes_on_youtube_id"
  end

  create_table "today_youtubes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id"
    t.date "date"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "unit_groups", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "unit_groups_youtubes", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "youtube_id", null: false
    t.integer "unit_group_id", null: false
    t.index ["unit_group_id"], name: "index_unit_groups_youtubes_on_unit_group_id"
    t.index ["youtube_id"], name: "index_unit_groups_youtubes_on_youtube_id", unique: true
  end

  create_table "ustream_milestones", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "ustream_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "ustream_witticisms", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "ustream_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.time "play_time"
  end

  create_table "ustreams", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.string "thumbnail", null: false
    t.datetime "published", precision: nil, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "view_counts", null: false
    t.index ["id"], name: "index_ustreams_on_id", unique: true
  end

  create_table "youtube_channels", charset: "utf8mb3", force: :cascade do |t|
    t.string "youtube_channel_id"
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_youtube_channels_on_name", unique: true
    t.index ["youtube_channel_id"], name: "index_youtube_channels_on_youtube_channel_id", unique: true
  end

  create_table "youtubes", id: false, charset: "utf8mb3", force: :cascade do |t|
    t.string "id", null: false, collation: "utf8mb3_unicode_ci"
    t.string "title", null: false, collation: "utf8mb3_unicode_ci"
    t.string "original_title", null: false, collation: "utf8mb3_unicode_ci"
    t.string "url", null: false, collation: "utf8mb3_unicode_ci"
    t.string "thumbnail", null: false, collation: "utf8mb3_unicode_ci"
    t.datetime "published", precision: nil, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "amazon", collation: "utf8mb3_unicode_ci"
    t.integer "view_counts", null: false
    t.string "ustream_id", collation: "utf8mb3_unicode_ci"
    t.date "release_at"
    t.text "memo"
    t.string "youtube_channel_id"
    t.string "youtube_live_id"
    t.boolean "youtube_live_flag", default: false, null: false
    t.index ["id"], name: "index_youtubes_on_id", unique: true
    t.index ["youtube_channel_id"], name: "index_youtubes_on_youtube_channel_id"
  end

end
