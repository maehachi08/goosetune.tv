class Api::V2::UstreamsController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # Ustreamトップで必要な情報を取得
  # /api/v2/ustreams/
  #==========================
  def index
    # /api/v2/youtubes?limit=10 などで取得件数を指定できます(default: 4)
    limit = params[:limit] ? params[:limit] : 4

    # 新しい順
    _desc = Ustream.all.order('published DESC').limit(limit)
    desc = {
      'title' => 'desc_ustream',
      'route' => '/ustreams/desc',
      'entry' => _desc,
      'url'   => 'http://api.goosetune.tv/api/v2/ustreams/desc',
    }

    # 古い順
    _asc = Ustream.all.order('published ASC').limit(limit)
    asc = {
      'title' => 'asc_ustream',
      'route' => '/ustreams/asc',
      'entry' => _asc,
      'url'   => 'http://api.goosetune.tv/api/v2/ustreams/asc',
    }

    # 再生回数の多い順
    _view_counts = Ustream.order('view_counts DESC').limit(limit)
    view_counts = {
      'title' => 'view_counts_ustream',
      'route' => '/ustreams/view_counts',
      'entry' => _view_counts,
      'url'   => 'http://api.goosetune.tv/api/v2/ustreams/view_counts',
    }

    # HOYから検索
    _hoy = {}
    # HOYリストから年度の降順(新しい順)に4つを取り出して最新順にreverseする
    Ustream.get_hoy_list.sort_by{|key,val| key}.last(limit.to_i).reverse.each do |k,v|
      # ustreamエントリが入る v 変数が配列になってしまうのを防ぐため
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

    @response_data = {
      'contents': ret,
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # 新しい順(降順)
  # /api/v2/ustreams/desc
  #==========================
  def desc
    ustreams = Ustream.all.order('published DESC').page(params[:page])
    @response_data = {
      'contents': ustreams,
      'common': @common_data
    }
    resources_with_pagination(ustreams)
    render json: @response_data
  end

  #==========================
  # 古い順(昇順)
  # /api/v2/ustreams/asc
  #==========================
  def asc
    ustreams = Ustream.all.order('published ASC').page(params[:page])
    @response_data = {
      'contents': ustreams,
      'common': @common_data
    }
    resources_with_pagination(ustreams)
    render json: @response_data
  end

  #==========================
  # 再生回数の多い順(降順)
  # /api/v2/ustreams/view_counts
  #==========================
  def view_counts
    ustreams = Ustream.all.order('view_counts DESC').page(params[:page])
    @response_data = {
      'contents': ustreams,
      'common': @common_data
    }
    resources_with_pagination(ustreams)
    render json: @response_data
  end

  #==========================
  # HOY一覧から検索
  # /api/v2/ustreams/hoy
  #==========================
  def hoy
    ustreams = Ustream.get_hoy_list
    @response_data = {
      'contents': ustreams,
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # HOYから検索
  # /api/v2/ustreams/hoy/:year
  #==========================
  def hoy_by_year
    year = params[:year]
    ustream = Hoy.get_hoy_ustream(year)
    youtubes = Hoy.year(year)

    @response_data = {
      'contents': {
          'ustream': ustream,
          'youtubes': youtubes
      },
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # id で1件取得
  # /api/v2/ustreams/:id
  #==========================
  def entry
    ustream = Ustream.find(params[:id])

    # ustream_idがHOY放送の場合はHOYエントリのYoutubeを返す
    if Hoy.hoy?(ustream_id=ustream.id)
      year = Hoy.get_year(ustream_id=ustream.id)
      youtubes = Hoy.year(year)
    else
      youtubes = Youtube.where(:ustream_id => ustream.id)
    end

    @response_data = {
      'contents':
        {
          'ustream' => ustream,
          'youtubes' => youtubes,
        },
      'common': @common_data
    }
    render json: @response_data
  end
end
