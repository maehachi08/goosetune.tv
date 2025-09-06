class YoutubesController < ApplicationController
  def index
    @title = 'YouTube検索 トップ'
    
    if ENV['API_MODE'] == 'true'
      params = URI.encode_www_form({ limit: 6 })
      api_path = "/api/v2/youtubes?#{params}"
      goosetune_api_get_data(params, api_path)
    else
      limit = 6

      # 新着
      _new_arrival = Youtube.new_arrival.order('published DESC').last(limit)
      new_arrival = {
                      'title' => 'new_arrival',
                      'entry' => _new_arrival,
                      'route' => '/youtubes/new_arrival',
                      'url'   => 'http://api.goosetune.tv/api/v2/youtubes/new_arrival',
                     }

      # Sing
      _sing = Youtube.sing.sample(limit.to_i)
      sing = {
               'title' => 'sing',
               'entry' => _sing,
               'route' => '/youtubes/sing',
               'path'  => '/api/v2/youtubes/sing',
             }

      # 再生回数の多い順
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
      cover = {}
      entry = []
      covers = Youtube.cover

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

      contents = {}
      contents.store( '新着動画', new_arrival)
      contents.store( 'Singを集めてみました', sing)
      contents.store( '年間カバー達', cover)
      contents.store( "タイトルが曲名ではなく'Play You. House'", playyouhouse)
      contents.store( '再生回数の多い順', view_counts)
      contents.store( '新しい順', desc)
      contents.store( '古い順', asc)
      @data = contents
      @common = {}
    end
  end

  def entry
    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/#{params[:youtube_id]}"
      goosetune_api_get_data(params, api_path)
      _member_ids = @data['member'].map { |name, member| member['id'] }
      @member_ids = _member_ids.join(",")
      @title = @data['youtube']['title']
    else
      @entry = Youtube.find(params[:youtube_id])
      @artists = entry_artists
      @members = entry_members

      if @entry.ustream_id.blank?
        from = @entry.published.to_datetime.strftime("%Y-%m-01").to_s
        to = from.to_datetime.end_of_month.to_s
        @relate_youtubes = Youtube.where(published: "#{from}"..."#{to}").where.not(:id => @entry.id).order('published DESC')
      else
        @ustream = Ustream.find(@entry.ustream_id)
        @relate_youtubes = @ustream.youtubes.where.not(:id => @entry.id)
      end

      @data = {
        'youtube'             => @entry,
        'artist'              => @artists,
        'member'              => @members,
        'ustream'             => @ustream ? @ustream : '',
        'relation'            => @relate_youtubes,
        'genres'              => @entry.genres,
        'musical_instruments' => @entry.musical_instruments,
      }
      _member_ids = @data['member'].map { |name, member| member['id'] }
      @member_ids = _member_ids.join(",")
      @title = @data['youtube']['title']
      @common = {}
    end
  end

  def today
    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i
    date = Date.new(year,month,day)

    @title = "今日のGoosehouse(#{date})"
    
    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/today/#{year}/#{month}/#{day}"
      goosetune_api_get_data(params, api_path)
    else
      youtube = TodayYoutube.get_today(date)
      @data = {
       'youtube' => youtube,
       'date' => date
      }
      @common = {}
    end
  end

  def new_arrival
    @title = "新着動画"

    if ENV['API_MODE'] == 'true'
      api_path = '/api/v2/youtubes/new_arrival'
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Youtube.new_arrival.page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def view_counts
    @title = "再生回数の多い順"

    if ENV['API_MODE'] == 'true'
      api_path = '/api/v2/youtubes/view_counts'
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Youtube.order('view_counts DESC').page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def desc
    @title = "すべての動画(新しい順)"

    if ENV['API_MODE'] == 'true'
      api_path = '/api/v2/youtubes/desc'
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Youtube.order('published DESC').page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def asc
    @title = "すべての動画(古い順)"

    if ENV['API_MODE'] == 'true'
      api_path = '/api/v2/youtubes/asc'
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Youtube.all.order('published ASC').page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def sing
    @title = "Singを集めてみました"

    if ENV['API_MODE'] == 'true'
      api_path = '/api/v2/youtubes/sing'
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Kaminari.paginate_array(Youtube.sing).page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def playyouhouse
    @title = "タイトルが曲名ではなく'Play You. House'"

    if ENV['API_MODE'] == 'true'
      api_path = '/api/v2/youtubes/playyouhouse'
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Youtube.playyouhouse.page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def cover
    @title = "年間カバー達"
    
    if ENV['API_MODE'] == 'true'
      api_path = '/api/v2/youtubes/cover'
      goosetune_api_get_data(params, api_path)
    else
      youtubes = Youtube.cover
      @data = {
        'youtubes' => youtubes
      }
      @common = {}
    end
  end

  def yearly_cover
    year = params[:year].to_s
    @title = "#{year}年のカバー達"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/cover/#{year}"
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Kaminari.paginate_array(Youtube.get_year(year)).page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def keyword
    keyword = params[:search][:keyword]
    @title = "キーワード: #{keyword}"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/keyword"
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      @data = {
        'youtubes' => Youtube.where("title like '%" + keyword + "%'").order('published DESC').page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def _upload_month
    year =  params['youtube']['published']['year']
    month =  params['youtube']['published']['month']
    redirect_to "/youtubes/upload_month/#{year}/#{month}"
  end

  def upload_month
    year =  params['year']
    month =  params['month']
    params.delete('year')
    params.delete('month')

    @title = "#{year}年#{month}月にYouTubeへアップロードされた動画"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/upload_month/#{year}/#{month}"
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    else
      from = Date.parse("#{year}-#{month}-01").strftime("%Y-%m-%d")
      to = from.to_datetime.end_of_month
      @data = {
        'youtubes' => Youtube.where(published: "#{from}"..."#{to.to_s}")
                       .order('published ASC')
                       .page(params[:page])
      }
      @headers = {}

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "entries"
      end
    end
  end

  def _live
    redirect_to "/youtubes/#{params[:youtube][:id]}"
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
