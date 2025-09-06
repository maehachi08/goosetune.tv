class Youtubes::HoyController < ApplicationController
  def index
    @title = "HOY(House Of the Year)"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/ustreams/hoy"
      goosetune_api_get_data(params, api_path)
    else
      @data = {}
      @data['hoys'] = ::Hoy.all_entries()
    end
  end

  def by_year
    year = params[:year]
    @title = " #{year}年のHOY(House Of the Year)"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/hoy/#{year}"
      goosetune_api_get_data(params, api_path)
    else
      @data = {}
      @data['entries'] = ::Hoy.year(year=year)
      @data['ustream'] = ::Hoy.get_hoy_ustream(year=year)
    end
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
