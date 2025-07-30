class UnitGroupsController < ApplicationController
  def index
    if ENV['API_MODE'] == 'false'
      _unit_groups = []
      cache_name = "#{controller_name}_#{action_name}_unit_group_all_list"

      all_unit_groups = Rails.cache.fetch(cache_name) do
        UnitGroup.all.to_a
      end

      all_unit_groups.each do |unit|
        cache_name = "#{controller_name}_#{action_name}_youtubes_of_#{unit.name}_thumbnail"
        thumbnail = Rails.cache.fetch(cache_name) do
           unit.youtubes.limit(1).order("RAND()").first.thumbnail
        end

        _unit_data = {}
        _unit_data['id']          = unit.id
        _unit_data['name']        = unit.name
        _unit_data['description'] = unit.description
        _unit_data['thumbnail']   = thumbnail
        _unit_groups << _unit_data
      end

      unit_groups = {
        'title' => 'unig_groups',
        'route' => 'unit_group_entry({unitGroupId: unit_group.id})',
        'entry' => _unit_groups,
        'url'   => 'http://api.goosetune.tv/api/v2/unit_group/{{ unit_group.id }}',
      }

      @data = {
        'unit_groups' => unit_groups
      }
    else
      api_path = "/api/v2/unit_groups"
      goosetune_api_get_data(params, api_path)
    end
  end

  def entry
    unit_group_id = params[:unit_group_id]

    if ENV['API_MODE'] == 'false'
      unit_group = UnitGroup.find(unit_group_id)
      youtubes = unit_group.youtubes.order('published DESC')
      paginated_youtubes = Kaminari.paginate_array(youtubes).page(params[:page])

      @data = {
        'unit_group' => unit_group,
        'youtubes' => paginated_youtubes
      }
      @headers = {
        'x-next-page' => paginated_youtubes.next_page ? paginated_youtubes.next_page.to_s : ''
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      end
    else
      api_path = "/api/v2/unit_groups/#{unit_group_id}"
      params.delete('unit_group_id')
      goosetune_api_get_paginate_data(params, api_path)
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
