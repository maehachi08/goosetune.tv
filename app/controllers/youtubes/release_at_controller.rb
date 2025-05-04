class Youtubes::ReleaseAtController < ApplicationController
  def year
    @title = "リリース検索(年別)"
    api_path = "/api/v2/youtubes/release_at/year"
    goosetune_api_get_data(params, api_path)
  end

  def years
    @title = "リリース検索(年代別)"
    api_path = "/api/v2/youtubes/release_at/years"
    goosetune_api_get_data(params, api_path)
  end

  def by_year
    year = params[:year]
    @title = "原曲が#{year}年にリリースされた曲"
    api_path = "/api/v2/youtubes/release_at/year/#{year}"
    goosetune_api_get_paginate_data(params, api_path)

    render "youtubes/entries"
  end

  def by_years
    years = params[:years]
    @title = "原曲が#{years}年代にリリースされた曲"
    api_path = "/api/v2/youtubes/release_at/years/#{years}"
    goosetune_api_get_paginate_data(params, api_path)

    render "youtubes/entries"
  end

  private
  def goosetune_api
    GoosetuneApi.new
  end

  def goosetune_api_get_data(params, api_path)
    data = goosetune_api.get_data(params, api_path)
    @data = data['contents']
    @common = data['common']
  end

  def goosetune_api_get_paginate_data(params, api_path)
    @data, @common, @headers = goosetune_api.get_paginate_data(params, api_path)
  end
end
