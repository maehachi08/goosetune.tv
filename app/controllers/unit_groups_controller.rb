class UnitGroupsController < ApplicationController
  def index
    api_path = "/api/v2/unit_groups"
    goosetune_api_get_data(params, api_path)
  end

  def entry
    unit_group_id = params[:unit_group_id]
    api_path = "/api/v2/unit_groups/#{unit_group_id}"
    params.delete('unit_group_id')
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
