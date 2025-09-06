class MembersController < ApplicationController
  def index
    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/members"
      goosetune_api_get_data(params, api_path)
    else
      members = Rails.cache.fetch("cache_members_controller_index_member_all") do
        Member.all
      end

      @data = {
        'refine_members' => members
      }
    end
  end

  def entry
    member_id = params[:member_id]

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/members/#{member_id}"
      params.delete('member_id')
      goosetune_api_get_paginate_data(params, api_path)
    else
      member = Member.find(member_id)
      entries = member.youtubes.order('published DESC')
      paginated_entries = Kaminari.paginate_array(entries).page(params[:page])

      @data = {
        'member' => member,
        'youtubes' => paginated_entries
      }
      @headers = {
        'x-next-page' => paginated_entries.next_page ? paginated_entries.next_page.to_s : ''
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      end
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
