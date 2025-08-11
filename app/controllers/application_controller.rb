class ApplicationController < ActionController::Base
  include Api::V2::ApplicationHelper
  include Api::V2::MembersHelper
  include Api::V2::MusicalInstrumentsHelper
  before_action :common_data


  private

  def common_data
    @common_data = {
        "select_form_of_upload_month":
        {
            "first_entry_year":  DateTime.parse( first_entry_datetime ).year,
            "latest_entry_year": DateTime.parse( latest_entry_datetime ).year
        },
        "select_form_of_ustream":      ustream_id_title_array,
        "select_form_of_youtube_live": youtube_live_id_title_array
    }
    # ビューで@commonとしてアクセスできるように別名も設定
    @common = @common_data
  end

  def append_info_to_payload(payload)
    super
    payload[:ip] = request.remote_ip
    payload[:host] = request.host
    payload[:referer] = request.referer
    payload[:user_agent] = request.user_agent
  end

end
