module Api::V2::ApplicationHelper
  def first_entry_datetime
    cache_name = "cache_one_youtube_entry_order_by_asc"
    first_entry = Rails.cache.fetch(cache_name) do
      ::Youtube.order('published ASC').first
    end
    first_entry.published.to_time.to_datetime.to_s
  end

  def latest_entry_datetime
    cache_name = "cache_one_youtube_entry_order_by_desc"
    latest_entry = Rails.cache.fetch(cache_name) do
      ::Youtube.order('published DESC').first
    end
    latest_entry.published.to_time.to_datetime.to_s
  end

  def ustream_id_title_array
    ret = []
    cache_name = "cache_all_youtubes_order_by_desc_id_title"
    entries = Rails.cache.fetch(cache_name) do
      ::Ustream.order('published DESC').pluck(:id, :title)
    end
    entries.each do |entry|
      ret << {"id": entry[0], "title": entry[1]}
    end
    ret
  end

  def youtube_live_id_title_array
    ret = []
    cache_name = "cache_youtubes_with_youtube_live_flag_order_by_desc_id_title"
    entries = Rails.cache.fetch(cache_name) do
      ::Youtube.where(:youtube_live_flag => true).order('published DESC').pluck(:id, :title)
    end
    entries.each do |entry|
      ret << {"id": entry[0], "title": entry[1]}
    end
    ret
  end
end
