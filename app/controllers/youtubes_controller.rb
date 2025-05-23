class YoutubesController < ApplicationController
  def index
    params = URI.encode_www_form({ limit: 6 })
    api_path = "/api/v2/youtubes?#{params}"
    goosetune_api_get_data(params, api_path)
    @title = 'YouTube検索 トップ'
  end

  def entry
    api_path = "/api/v2/youtubes/#{params[:youtube_id]}"
    goosetune_api_get_data(params, api_path)
    _member_ids = @data['member'].map { |name, member| member['id'] }
    @member_ids = _member_ids.join(",")
    @title = @data['youtube']['title']
  end

  def today
    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i
    date = Date.new(year,month,day)

    @title = "今日のGoosehouse(#{date})"
    api_path = "/api/v2/youtubes/today/#{year}/#{month}/#{day}"
    goosetune_api_get_data(params, api_path)
  end

  def new_arrival
    @title = "新着動画"
    api_path = '/api/v2/youtubes/new_arrival'
    goosetune_api_get_data(params, api_path)
    render "entries"
  end

  def view_counts
    @title = "再生回数の多い順"
    api_path = '/api/v2/youtubes/view_counts'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def desc
    @title = "すべての動画(新しい順)"
    api_path = '/api/v2/youtubes/desc'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def asc
    @title = "すべての動画(古い順)"
    api_path = '/api/v2/youtubes/asc'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def sing
    @title = "Singを集めてみました"
    api_path = '/api/v2/youtubes/sing'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def playyouhouse
    @title = "タイトルが曲名ではなく'Play You. House'"
    api_path = '/api/v2/youtubes/playyouhouse'
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def cover
    @title = "年間カバー達"
    api_path = '/api/v2/youtubes/cover'
    goosetune_api_get_data(params, api_path)
  end

  def yearly_cover
    year = params[:year].to_s
    @title = "#{year}年のカバー達"
    api_path = "/api/v2/youtubes/cover/#{year}"
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
  end

  def keyword
    keyword = params[:search][:keyword]
    @title = "キーワード: #{keyword}"
    api_path = "/api/v2/youtubes/keyword/#{keyword}"
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
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
    api_path = "/api/v2/youtubes/upload_month/#{year}/#{month}"
    goosetune_api_get_paginate_data(params, api_path)
    render "entries"
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
end
