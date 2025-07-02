class Api::V2::YoutubesController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # YouTube検索トップ
  # /api/v2/youtubes/
  #==========================
  def index
    limit = params[:limit] ? params[:limit] : 4

    # 新着
    _new_arrival = Youtube.new_arrival.order('published DESC').last(limit)
    new_arrival = {
                    'title' => 'new_arrival',
                    'entry' => _new_arrival,
                    'route' => '/youtubes/new_arrival',
                    'url'   => 'http://api.goosetune.tv/api/v2/youtubes/new_arrival',
                   }

    # Sing
    # Youtube.singメソッドはmodelオプジェクトではなくarrayを返す
    _sing = Youtube.sing.sample(limit.to_i)
    sing = {
             'title' => 'sing',
             'entry' => _sing,
             'route' => '/youtubes/sing',
             'path'  => '/api/v2/youtubes/sing',
           }

    # 再生回数の多い順
    #   常に再生回数トップエントリを取得
    _view_counts = Youtube.order('view_counts DESC').limit(limit)
    view_counts = {
                    'title' => 'view_counts',
                    'entry' => _view_counts,
                    'route' => '/youtubes/view_counts',
                    'url'   => 'http://api.goosetune.tv/api/v2/youtubes/view_counts',
                  }


    # 公開日降順
    _desc = Youtube.all.order('published DESC').order("RAND()").limit(limit)
    desc = {
             'title' => 'desc',
             'entry' => _desc,
             'route' => '/youtubes/desc',
             'url'   => 'http://api.goosetune.tv/api/v2/youtubes/desc',
           }

    # 公開日昇順
    _asc = Youtube.all.order('published ASC').limit(limit).order("RAND()")
    asc = {
            'title' => 'asc',
            'entry' => _asc,
            'route' => '/youtubes/asc',
            'url'   => 'http://api.goosetune.tv/api/v2/youtubes/asc',
          }

    # 年間のカバー達
    # トップページ表示用の情報取得
    #
    # - title,next_linkは共通
    # - thumbnailsとurlはハッシュを生成する
    cover = {}
    entry = []
    covers = Youtube.cover

    # { "title": "2010年のカバー達", "thumbnail": "サムネイルURL" } の配列を作成
    covers.keys.reverse[0,limit.to_i].each do |year|
      cover = { "year": "#{year}", "title": "#{year}年のカバー達", "thumbnail": covers[year].thumbnail }
      entry << cover
    end

    cover = {
              'title' => 'cover',
              'entry' => entry,
              'route' => '/youtubes/cover',
              'url'   => 'http://api.goosetune.tv/api/v2/youtubes/asc',
            }

    # タイトルが曲名ではなく'Play You. House'の動画
    _playyouhouse = Youtube.playyouhouse.limit(limit).order("RAND()")
    playyouhouse = {
                     'title' => 'playyouhouse',
                     'entry' => _playyouhouse,
                     'route' => '/youtubes/playyouhouse',
                     'url'   => 'http://api.goosetune.tv/api/v2/youtubes/playyouhouse',
                   }

    @response_data = {}
    contents = {}
    contents.store( '新着動画', new_arrival)
    contents.store( 'Singを集めてみました', sing)
    contents.store( '年間カバー達', cover)
    contents.store( "タイトルが曲名ではなく'Play You. House'", playyouhouse)
    contents.store( '再生回数の多い順', view_counts)
    contents.store( '新しい順', desc)
    contents.store( '古い順', asc)
    @response_data.store('contents', contents)
    @response_data.store('common', @common_data)

    render json: @response_data
  end

  #==========================
  # キーワード検索
  # /api/v2/youtubes/keyword
  #==========================
  def keyword
    keyword = params[:search] && params[:search][:keyword] ? params[:search][:keyword] : params[:keyword]
    youtubes = Youtube.where("title like '%" + keyword + "%'").order('published DESC').page(params[:page])
    resources_with_pagination(youtubes)
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # アップロード月検索
  # /api/v2/youtubes/upload_month/:year/:month
  #==========================
  def upload_month
    year = params[:year]
    month = params[:month]

    @from = Date.parse("#{year}-#{month}-01").strftime("%Y-%m-%d")
    @to = @from.to_datetime.end_of_month
    youtubes = Youtube.where(published: "#{@from}"..."#{@to.to_s}")
                .order('published ASC')
                .page(params[:page])

    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }

    #resources_with_pagination(Kaminari.paginate_array(youtubes).page(params[:page]))
    resources_with_pagination(youtubes)
    render json: @response_data
  end

  #==========================
  # 新着動画
  # /api/v2/youtubes/new_arrival
  #==========================
  def new_arrival
    youtubes = Youtube.new_arrival.page(params[:page])
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end

  #==========================
  # 新しい順(降順)
  # /api/v2/youtubes/desc
  #==========================
  def desc
    youtubes = Youtube.order('published DESC')
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination( Kaminari.paginate_array(youtubes).page(params[:page]) )
    render json: @response_data
  end

  #==========================
  # 古い順(昇順)
  # /api/v2/youtubes/asc
  #==========================
  def asc
    youtubes = Youtube.all.order('published ASC').page(params[:page])
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end

  #==========================
  # 再生回数の多い順(降順)
  # /api/v2/youtubes/view_counts
  #==========================
  def view_counts
    youtubes = Youtube.order('view_counts DESC').page(params[:page])
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end

  #==========================
  # titleがPlay You. House'
  # /api/v2/youtubes/playyouhouse
  #==========================
  def playyouhouse
    youtubes = Youtube.playyouhouse.page(params[:page])
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end

  #==========================
  # Sing動画を全件取得
  # /api/v2/youtubes/sing
  #==========================
  def sing
    youtubes = Kaminari.paginate_array(Youtube.sing).page(params[:page])
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end

  #==========================
  # 年間カバーの一覧取得
  # /api/v2/youtubes/cover
  #==========================
  def cover
    youtubes = Youtube.cover
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # 年間カバー動画を取得
  # /api/v2/youtubes/cover/:year
  #==========================
  def cover_by_year
    youtubes = Youtube.get_year(params[:year])
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination( Kaminari.paginate_array(youtubes).page(params[:page]) )
    render json: @response_data
  end

  #==========================
  # 今日のGoosehouse
  # /api/v2/youtubes/today/:year/:month/:day
  #==========================
  def today
    date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    youtube = TodayYoutube.get_today(date)
    @response_data = {
      'contents': {
       'youtube': youtube,
       'date': date
      },
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # YouTube Live配信のアーカイブ
  # /api/v2/youtubes/lives
  #==========================
  def lives
    youtubes = Youtube.where( :youtube_live_flag => true ).page(params[:page])
    @response_data = {
      'contents': {
        'youtubes': youtubes
      },
      'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end

  #==========================
  # YouTubeエントリの詳細
  # /api/v2/youtubes/:id
  #==========================
  def entry
    @entry = Youtube.find(params[:id])
    @artists = entry_artists
    @members = entry_members

    # TODO: アーティストやジャンルでの関連も提案できるように検討したい
    #
    # 関連動画の抽出
    # @entry.ustream_id が empty でも nil でも対応するために blank? メソッドを使用する
    #
    #   @entry.ustream_id に値が入っている場合
    #   => 同Ustreamに紐付く動画
    #
    #   @entry.ustream_id に値が入っていない場合
    #   => 同月にアップロードされた動画
    #      Ustreamアーカイブが残っていない or Ustream演奏分の動画ではない(MVとかYouTube配信以降)
    if @entry.ustream_id.blank?
      from = @entry.published.to_datetime.strftime("%Y-%m-01").to_s
      to = from.to_datetime.end_of_month.to_s
      @relate_youtubes = Youtube.where(published: "#{from}"..."#{to}").where.not(:id => @entry.id).order('published DESC')
    else
      @ustream = Ustream.find(@entry.ustream_id)
      @relate_youtubes = @ustream.youtubes.where.not(:id => @entry.id)
    end

    @response_data = {
      'contents': {
        'youtube'             => @entry,
        'artist'              => @artists,
        'member'              => @members,
        'ustream'             => @ustream ? @ustream : '',
        'relation'            => @relate_youtubes,
        'genres'              => @entry.genres,
        'musical_instruments' => @entry.musical_instruments,
      },
      'common': @common_data
    }

    render json: @response_data
  end


  private
  def entry_artists
    artists = {}
    @entry.artists.each do |artist|
      artists[artist.name] = artist
    end
    artists
  end

  def entry_members
    members = {}
    @entry.members.to_a.each do |member|
      members[member.name] = member
    end
    members
  end

end
