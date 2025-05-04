class Api::V2::Youtubes::HoyController < ApplicationController
  #==========================
  # HOY - 年毎の一覧
  # /api/v2/youtubes/hoy
  #==========================
  def index
    hoys = ::Hoy.all_entries()
    @response_data = {
      'contents': hoys,
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # HOY - 年毎のエントリ
  # /api/v2/youtubes/hoy/:year
  #==========================
  def by_year
    year = params[:year]
    hoy = ::Hoy.year(yesr=year)
    ustream = ::Hoy.get_hoy_ustream(year=year)
    @response_data = {
      'contents': {
        "entries": hoy,
        "ustream": ustream
      },
      'common': @common_data
    }
    render json: @response_data
  end


end
