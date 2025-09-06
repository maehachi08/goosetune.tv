class ArtistsController < ApplicationController
  def index
    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/artists"
      goosetune_api_get_data(params, api_path)
    else
      # アーティストを50音別に分類
      @artists_a  = Artist.where('reading regexp \'^(ア|イ|ウ|エ|オ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_ka = Artist.where('reading regexp \'^(ガ|ギ|グ|ゲ|ゴ|カ|キ|ク|ケ|コ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_sa = Artist.where('reading regexp \'^(ザ|ジ|ズ|ゼ|ゾ|サ|シ|ス|セ|ソ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_ta = Artist.where('reading regexp \'^(ダ|ヂ|ヅ|デ|ド|タ|チ|ツ|テ|ト)\' and reading not regexp \'^(ヤ|ユ|ヨ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_na = Artist.where('reading regexp \'^(ナ|ニ|ヌ|ネ|ノ)\' and reading not regexp \'^(ラ|リ|ル|レ|ロ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_ha = Artist.where('reading regexp \'^(パ|ピ|プ|ペ|ポ|バ|ビ|ブ|ベ|ボ|ハ|ヒ|フ|ヘ|ホ)\' and reading not regexp \'^(ワ|ヲ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_ma = Artist.where('reading regexp \'^(マ|ミ|ム|メ|モ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_ya = Artist.where('reading regexp \'^(ヤ|ユ|ヨ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_ra = Artist.where('reading regexp \'^(ラ|リ|ル|レ|ロ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
      @artists_wa = Artist.where('reading regexp \'^(ワ|ヲ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )

      @data = {
        'ア' => {
          'route' => 'a',
          'entry' => @artists_a,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'カ' => {
          'route' => 'ka',
          'entry' => @artists_ka,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'サ' => {
          'route' => 'sa',
          'entry' => @artists_sa,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'タ' => {
          'route' => 'ta',
          'entry' => @artists_ta,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'ナ' => {
          'route' => 'na',
          'entry' => @artists_na,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'ハ' => {
          'route' => 'ha',
          'entry' => @artists_ha,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'マ' => {
          'route' => 'ma',
          'entry' => @artists_ma,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'ヤ' => {
          'route' => 'ya',
          'entry' => @artists_ya,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'ラ' => {
          'route' => 'ra',
          'entry' => @artists_ra,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        },
        'ワ' => {
          'route' => 'wa',
          'entry' => @artists_wa,
          'url' => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
        }
      }
    end
  end

  def entry
    ids = params[:artist_id].to_s

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/artists/#{ids}"
      goosetune_api_get_paginate_data(params, api_path)
    else
      artist_ids = ids.split(',')
      artist = Artist.find(artist_ids)
      youtubes = Kaminari.paginate_array(::Artist.get_youtubes(artist_ids)).page(params[:page])

      @data = {
        'artist' => artist,
        'youtubes' => youtubes
      }
      @headers = {}

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
