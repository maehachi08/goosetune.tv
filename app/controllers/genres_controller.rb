class GenresController < ApplicationController
  def index
    api_path = "/api/v2/genres"
    goosetune_api_get_data(params, api_path)
  end

  def entry
    genre_id = params[:genre_id]
    api_path = "/api/v2/genres/#{genre_id}"
    params.delete('genre_id')
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
