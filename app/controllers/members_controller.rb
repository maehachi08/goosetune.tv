class MembersController < ApplicationController
  def index
    api_path = "/api/v2/members"
    goosetune_api_get_data(params, api_path)
  end

  def entry
    member_id = params[:member_id]
    api_path = "/api/v2/members/#{member_id}"
    params.delete('member_id')
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
