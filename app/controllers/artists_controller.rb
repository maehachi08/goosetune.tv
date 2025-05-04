class ArtistsController < ApplicationController
  def index
    api_path = "/api/v2/artists"
    goosetune_api_get_data(params, api_path)
  end

  def entry
    ids = params[:artist_id].to_s
    api_path = "/api/v2/artists/#{ids}"
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
