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
    begin
      cache_name = "cache_all_ustreams_order_by_desc_id_title"
      entries = Rails.cache.fetch(cache_name) do
        Rails.logger.info "DEBUG: Fetching Ustream data from database"
        result = ::Ustream.order('published DESC').pluck(:id, :title)
        Rails.logger.info "DEBUG: Found #{result.length} Ustream entries in database"
        result
      end
      Rails.logger.info "DEBUG: Got #{entries.length} entries from cache/db"
      entries.each do |entry|
        Rails.logger.info "DEBUG: Ustream entry - ID: #{entry[0]}, Title: '#{entry[1]}'" if entry[0]
        ret << {"id" => entry[0], "title" => entry[1]}
      end
      Rails.logger.info "DEBUG: Returning #{ret.length} ustream items"
    rescue => e
      Rails.logger.error "ERROR in ustream_id_title_array: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
    ret
  end

  def youtube_live_id_title_array
    ret = []
    begin
      cache_name = "cache_youtubes_with_youtube_live_flag_order_by_desc_id_title"
      entries = Rails.cache.fetch(cache_name) do
        Rails.logger.info "DEBUG: Fetching YouTube Live data from database"
        result = ::Youtube.where(:youtube_live_flag => true).order('published DESC').pluck(:id, :title)
        Rails.logger.info "DEBUG: Found #{result.length} YouTube Live entries in database"
        result
      end
      Rails.logger.info "DEBUG: Got #{entries.length} YouTube Live entries from cache/db"
      entries.each do |entry|
        Rails.logger.info "DEBUG: YouTube Live entry - ID: #{entry[0]}, Title: '#{entry[1]}'" if entry[0]
        ret << {"id" => entry[0], "title" => entry[1]}
      end
      Rails.logger.info "DEBUG: Returning #{ret.length} youtube live items"
    rescue => e
      Rails.logger.error "ERROR in youtube_live_id_title_array: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
    ret
  end
end
