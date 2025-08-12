class ApplicationController < ActionController::Base
  include Api::V2::ApplicationHelper
  include Api::V2::MembersHelper
  include Api::V2::MusicalInstrumentsHelper
  before_action :common_data


  private

  def common_data
    begin
      ustream_data = ustream_id_title_array
      youtube_live_data = youtube_live_id_title_array

      Rails.logger.info "DEBUG: ustream_data count: #{ustream_data.length}"
      Rails.logger.info "DEBUG: youtube_live_data count: #{youtube_live_data.length}"

      @common_data = {
          "select_form_of_upload_month" =>
          {
              "first_entry_year" =>  DateTime.parse( first_entry_datetime ).year,
              "latest_entry_year" => DateTime.parse( latest_entry_datetime ).year
          },
          "select_form_of_ustream" =>      ustream_data,
          "select_form_of_youtube_live" => youtube_live_data
      }
      # ビューで@commonとしてアクセスできるように別名も設定
      @common = @common_data

      Rails.logger.info "DEBUG: @common keys: #{@common.keys}"
      Rails.logger.info "DEBUG: @common['select_form_of_ustream'] present: #{@common['select_form_of_ustream'].present?}"
      Rails.logger.info "DEBUG: @common['select_form_of_youtube_live'] present: #{@common['select_form_of_youtube_live'].present?}"
      if @common['select_form_of_ustream'].present?
        Rails.logger.info "DEBUG: @common['select_form_of_ustream'] count: #{@common['select_form_of_ustream'].length}"
      end
      if @common['select_form_of_youtube_live'].present?
        Rails.logger.info "DEBUG: @common['select_form_of_youtube_live'] count: #{@common['select_form_of_youtube_live'].length}"
      end

    rescue => e
      Rails.logger.error "ERROR in common_data: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      # エラーの場合は空の@commonを設定（フォールバックが使われる）
      @common = nil
    end
  end

  def append_info_to_payload(payload)
    super
    payload[:ip] = request.remote_ip
    payload[:host] = request.host
    payload[:referer] = request.referer
    payload[:user_agent] = request.user_agent
  end

end
