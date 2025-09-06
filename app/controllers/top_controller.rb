class TopController < ApplicationController
  def index
    if ENV['API_MODE'] == 'true'
      params = URI.encode_www_form({ limit: 6 })
      api_path = "/api/v2/youtubes?#{params}"
      data = goosetune_api.get_data(params, api_path)
      @data = data['contents']
      @common = data['common']
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
        if covers[year]
          cover = { "year" => "#{year}", "title" => "#{year}年のカバー達", "thumbnail" => covers[year].thumbnail }
          entry << cover
        end
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

  private
  def goosetune_api
    GoosetuneApi.new
  end
end
