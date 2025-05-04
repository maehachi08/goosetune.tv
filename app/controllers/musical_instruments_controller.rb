class MusicalInstrumentsController < ApplicationController
  def index
    api_path = "/api/v2/musical_instruments"
    goosetune_api_get_data(params, api_path)
  end

  def entry
    api_path = "/api/v2/musical_instruments/#{params[:musical_instruments_id]}"
    goosetune_api_get_paginate_data(params, api_path)
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
