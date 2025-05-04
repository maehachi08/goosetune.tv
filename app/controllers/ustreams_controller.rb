class UstreamsController < ApplicationController
  def index
    params = URI.encode_www_form({ limit: 6 })
    api_path = "/api/v2/ustreams?#{params}"
    goosetune_api_get_data(params, api_path)
  end

  def entry
    api_path = "/api/v2/ustreams/#{params[:ustream_id]}"
    goosetune_api_get_data(params, api_path)
  end

  def hoy
    @title = "HOY"
    api_path = '/api/v2/ustreams/hoy'
    goosetune_api_get_data(params, api_path)
  end

  def view_counts
    @title = "再生回数の多い順"
    api_path = '/api/v2/ustreams/view_counts'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def desc
    @title = "すべての動画(新しい順)"
    api_path = '/api/v2/ustreams/desc'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def asc
    @title = "すべての動画(古い順)"
    api_path = '/api/v2/ustreams/asc'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def _published
    redirect_to "/ustreams/#{params[:ustreams][:id]}"
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
