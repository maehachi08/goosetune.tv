class UstreamsController < ApplicationController
  def index
    if ENV['API_MODE'] == 'false'
      limit = params[:limit] ? params[:limit] : 4

      _desc = Ustream.all.order('published DESC').limit(limit)
      desc = {
        'title' => 'desc_ustream',
        'route' => '/ustreams/desc',
        'entry' => _desc,
        'url'   => 'http://api.goosetune.tv/api/v2/ustreams/desc',
      }

      _asc = Ustream.all.order('published ASC').limit(limit)
      asc = {
        'title' => 'asc_ustream',
        'route' => '/ustreams/asc',
        'entry' => _asc,
        'url'   => 'http://api.goosetune.tv/api/v2/ustreams/asc',
      }

      _view_counts = Ustream.order('view_counts DESC').limit(limit)
      view_counts = {
        'title' => 'view_counts_ustream',
        'route' => '/ustreams/view_counts',
        'entry' => _view_counts,
        'url'   => 'http://api.goosetune.tv/api/v2/ustreams/view_counts',
      }

      _hoy = {}
      Ustream.get_hoy_list.sort_by{|key,val| key}.last(limit.to_i).reverse.each do |k,v|
        _hoy[ k ] = v
      end

      hoy = {
        'title' => 'hoy_ustream',
        'route' => '/ustreams/hoy',
        'entry' => _hoy,
        'url'   => 'http://api.goosetune.tv/api/v2/ustreams/hoy',
      }
      ret = {}
      ret.store( '新しい順', desc)
      ret.store( '古い順', asc)
      ret.store( '再生回数の多い順', view_counts)
      ret.store( 'HOYから検索', hoy)

      @data = ret
    else
      params = URI.encode_www_form({ limit: 6 })
      api_path = "/api/v2/ustreams?#{params}"
      goosetune_api_get_data(params, api_path)
    end
  end

  def entry
    if ENV['API_MODE'] == 'false'
      ustream = Ustream.find(params[:ustream_id])

      if Hoy.hoy?(ustream_id=ustream.id)
        year = Hoy.get_year(ustream_id=ustream.id)
        youtubes = Hoy.year(year)
      else
        youtubes = Youtube.where(:ustream_id => ustream.id)
      end

      @data = {
        'ustream' => ustream,
        'youtubes' => youtubes,
      }
    else
      api_path = "/api/v2/ustreams/#{params[:ustream_id]}"
      goosetune_api_get_data(params, api_path)
    end
  end

  def hoy
    @title = "HOY"
    if ENV['API_MODE'] == 'false'
      ustreams = Ustream.get_hoy_list
      @data = ustreams
    else
      api_path = '/api/v2/ustreams/hoy'
      goosetune_api_get_data(params, api_path)
    end
  end

  def view_counts
    @title = "再生回数の多い順"
    if ENV['API_MODE'] == 'false'
      @data = {
        'entries' => Ustream.all.order('view_counts DESC').page(params[:page])
      }
      @headers = {
        'x-next-page' => @data['entries'].next_page ? @data['entries'].next_page.to_s : ''
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['entries'] }, layout: false
      else
        render "entries"
      end
    else
      api_path = '/api/v2/ustreams/view_counts'
      goosetune_api_get_paginate_data(params, api_path)
      render "entries"
    end
  end

  def desc
    @title = "すべての動画(新しい順)"
    if ENV['API_MODE'] == 'false'
      @data = {
        'entries' => Ustream.all.order('published DESC').page(params[:page])
      }
      @headers = {
        'x-next-page' => @data['entries'].next_page ? @data['entries'].next_page.to_s : ''
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['entries'] }, layout: false
      else
        render "entries"
      end
    else
      api_path = '/api/v2/ustreams/desc'
      goosetune_api_get_paginate_data(params, api_path)
      render "entries"
    end
  end

  def asc
    @title = "すべての動画(古い順)"
    if ENV['API_MODE'] == 'false'
      @data = {
        'entries' => Ustream.all.order('published ASC').page(params[:page])
      }
      @headers = {
        'x-next-page' => @data['entries'].next_page ? @data['entries'].next_page.to_s : ''
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['entries'] }, layout: false
      else
        render "entries"
      end
    else
      api_path = '/api/v2/ustreams/asc'
      goosetune_api_get_paginate_data(params, api_path)
      render "entries"
    end
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
