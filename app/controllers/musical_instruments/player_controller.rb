class MusicalInstruments::PlayerController < ApplicationController

  # 演奏者検索
  def index
    api_path = "/api/v2/musical_instruments/player"
    goosetune_api_get_data(params, api_path)
    @musical_instrument_ids = @data.keys
  end

  # 演奏者検索: musical_instruments_name
  def list
    api_path = "/api/v2/musical_instruments/#{params[:musical_instruments_id]}/player"
    goosetune_api_get_data(params, api_path)
  end

  # 演奏者検索: musical_instruments_name(member_name)
  def entry
    api_path = "/api/v2/musical_instruments/#{params[:musical_instruments_id]}/player/#{params['member_id']}"
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
