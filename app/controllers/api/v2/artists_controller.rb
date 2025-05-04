class Api::V2::ArtistsController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # アーティスト検索 - トップ
  # /api/v2/artists
  #==========================
  def index
    # readingカラムがnullではないカラムを昇順で並べる
    # select count(*) from artists where reading is not null ORDER BY CAST(reading A CHAR) ASC;
    #
    # Rail5.1以降でSQL Injectionの危険性のあるSQL文については以下のような警告が出るので Arel.sql で安全なSQL文としてwrapする
    # Dangerous query method (method whose arguments are used as raw SQL) called with non-attribute argument(s): "cast(reading AS CHAR) ASC".This method should not be called with user-provided values, such as request parameters or model attributes. Known-safe values can be passed by wrapping them in Arel.sql().
    #
    # ア行から始まるアーティスト名のみ抽出
    # select * from artists where reading regexp '^(ア|イ|ウ|エ|オ)' ORDER BY CAST(reading AS CHAR) ASC;
    @artists_a  = Artist.where('reading regexp \'^(ア|イ|ウ|エ|オ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
    @artists_ka = Artist.where('reading regexp \'^(ガ|ギ|グ|ゲ|ゴ|カ|キ|ク|ケ|コ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
    @artists_sa = Artist.where('reading regexp \'^(ザ|ジ|ズ|ゼ|ゾ|サ|シ|ス|セ|ソ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )

    # :memo:
    # ヤ行が重複するようなので抽出しない
    # SELECT `artists`.* FROM `artists` WHERE (reading regexp '^(タ|チ|ツ|テ|ト)' and reading not regexp '^(ヤ|ユ|ヨ)')  ORDER BY cast(reading AS CHAR) ASC;
    @artists_ta = Artist.where('reading regexp \'^(ダ|ヂ|ヅ|デ|ド|タ|チ|ツ|テ|ト)\' and reading not regexp \'^(ヤ|ユ|ヨ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )

    # :memo:
    # ラ行が重複するようなので抽出しない
    # SELECT `artists`.* FROM `artists` WHERE (reading regexp '^(ナ|ニ|ヌ|ネ|ノ)' and reading not regexp '^(ラ|リ|ル|レ|ロ)')  ORDER BY cast(reading AS CHAR) ASC;
    @artists_na = Artist.where('reading regexp \'^(ナ|ニ|ヌ|ネ|ノ)\' and reading not regexp \'^(ラ|リ|ル|レ|ロ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )

    # :memo:
    # ワ行が重複するようなので抽出しない
    # SELECT `artists`.* FROM `artists` WHERE (reading regexp '^(ハ|ヒ|フ|ヘ|ホ)' and reading not regexp '^(ワ|ヲ)')  ORDER BY cast(reading AS CHAR) ASC;
    @artists_ha = Artist.where('reading regexp \'^(パ|ピ|プ|ペ|ポ|バ|ビ|ブ|ベ|ボ|ハ|ヒ|フ|ヘ|ホ)\' and reading not regexp \'^(ワ|ヲ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )

    @artists_ma = Artist.where('reading regexp \'^(マ|ミ|ム|メ|モ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
    @artists_ya = Artist.where('reading regexp \'^(ヤ|ユ|ヨ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
    @artists_ra = Artist.where('reading regexp \'^(ラ|リ|ル|レ|ロ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
    @artists_wa = Artist.where('reading regexp \'^(ワ|ヲ)\'').order( Arel.sql('cast(reading AS CHAR) ASC') )
    entry = {
         'ア'    => {
                        'route' => 'a',
                        'entry' => @artists_a,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'カ'    => {
                        'route' => 'ka',
                        'entry' => @artists_ka,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'サ'    => {
                        'route' => 'sa',
                        'entry' => @artists_sa,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'タ'    => {
                        'route' => 'ta',
                        'entry' => @artists_ta,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'ナ'    => {
                        'route' => 'na',
                        'entry' => @artists_na,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'ハ'    => {
                        'route' => 'ha',
                        'entry' => @artists_ha,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'マ'    => {
                        'route' => 'ma',
                        'entry' => @artists_ma,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'ヤ'    => {
                        'route' => 'ya',
                        'entry' => @artists_ya,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'ラ'    => {
                        'route' => 'ra',
                        'entry' => @artists_ra,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    },
         'ワ'    => {
                        'route' => 'wa',
                        'entry' => @artists_wa,
                        'url'   => 'http://api.goosetune.tv/api/v2/artist/{{ artist.id }}'
                    }
    }


    @response_data = {
        'contents': entry,
        'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # アーティスト検索 - ID検索
  # /api/v2/artists/:id
  #
  #   The params[:id] allow multiple resource id.
  #   When get request by the multiple resource id, resource ids conma delimited.
  #     e.g.)
  #     /api/v2/artists/100,101,102
  #==========================
  def entry
    # artist.youtubesの返し方メモ
    #   - .order('published DESC') しないと順番通り返せない
    #   - artist.youtubes に対して事前にpage パラメータを付加した状態で返す
    #     - これしないと最初の件数だけしか返せないよ...
    artist_ids = params[:id].to_s.split(',')
    artist = Artist.find(artist_ids)
    youtubes = Kaminari.paginate_array(::Artist.get_youtubes(artist_ids)).page(params[:page])
    @response_data = {
        'contents':
            {
                'artist' => artist,
                'youtubes'   => youtubes
            },
        'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end
end
