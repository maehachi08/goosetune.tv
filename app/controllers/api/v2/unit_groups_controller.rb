class Api::V2::UnitGroupsController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # ユニットグループ検索 - トップ
  # /api/v2/unit_groups
  #==========================
  def index
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

    @response_data = {
      'contents': {
        'unit_groups': unit_groups
      },
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # ユニットグループ検索 - ID検索
  # /api/v2/unit_groups/:id
  #==========================
  def entry
    # member.youtubesの返し方メモ
    #   - .order('published DESC') しないと順番通り返せない
    #   - member.youtubes に対して事前にpage パラメータを付加した状態で返す
    #     - * これしないと最初の件数だけしか返せないよ...
    unit_group = UnitGroup.find(params[:id])
    youtubes = unit_group.youtubes.order('published DESC')
    @response_data = {
      'contents': {
        'unit_group' => unit_group,
        'youtubes'   => youtubes
      },
      'common': @common_data
    }
    resources_with_pagination( Kaminari.paginate_array(youtubes).page(params[:page]) )
    render json: @response_data
  end
end
