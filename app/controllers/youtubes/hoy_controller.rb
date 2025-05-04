class Youtubes::HoyController < ApplicationController
  def index
    @title = "HOY(House Of the Year)"
    api_path = "/api/v2/ustreams/hoy"
    goosetune_api_get_data(params, api_path)
  end

  def by_year
    year = params[:year]
    @title = " #{year}年のHOY(House Of the Year)"
    api_path = "/api/v2/youtubes/hoy/#{year}"
    goosetune_api_get_data(params, api_path)
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
