class Api::V2::MembersController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # メンバー検索 - トップ
  # /api/v2/members
  #==========================
  def index
    members = Rails.cache.fetch("cache_members_controller_index_member_all") do
      Member.all
    end

    @response_data = {
        'contents': {
          'refine_members': members
        },
        'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # メンバー絞り込み検索
  # /api/v2/members/:id
  #==========================
  def entry
    member = Member.find(params[:id])
    entries = member.youtubes.order('published DESC')

    @response_data = {
        'contents':
            {
              'member'   => member,
              'youtubes' => entries
        },
        'common': @common_data
    }
    resources_with_pagination( Kaminari.paginate_array(entries).page(params[:page]) )
    render json: @response_data
  end
end
