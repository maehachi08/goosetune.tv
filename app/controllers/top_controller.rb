class TopController < ApplicationController
  def index
    params = URI.encode_www_form({ limit: 6 })
    api_path = "/api/v2/youtubes?#{params}"
    data = goosetune_api.get_data(params, api_path)
    @data = data['contents']
    @common = data['common']
  end

  private
  def goosetune_api
    GoosetuneApi.new
  end
end
