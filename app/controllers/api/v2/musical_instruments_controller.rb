class Api::V2::MusicalInstrumentsController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # 楽器検索 - トップ
  # /api/v2/musical_instruments
  #==========================
  def index
    _musical_instruments = []
    cache_name = "#{controller_name}_#{action_name}_musical_instruments_all"
    all_musical_instruments  = Rails.cache.fetch(cache_name) do
      MusicalInstrument.all
    end

    all_musical_instruments.each do |musical_instrument|
      data    = {}
      data['id']   = musical_instrument.id
      data['name'] = musical_instrument.name

      # ActiveRecord::AssociationRelation をeachで回さないと取得できなかった...
      cache_name = "#{controller_name}_#{action_name}_youtubes_of_#{musical_instrument.name}_thumbnail"
      data['thumbnail'] = Rails.cache.fetch(cache_name) do
        musical_instrument.youtubes.order("RAND()").limit(1).first.thumbnail
      end
      _musical_instruments << data
    end

     musical_instruments = {
      'title' => 'musical_instruments',
      'route' => 'musical_instrument_entry({MusicalInstrumentId: musical_instrument.id})',
      'entry' => _musical_instruments,
      'url'   => 'http://api.goosetune.tv/api/v2/musical_instruments',
    }

    ret = {}
    ret.store( 'musical_instruments', musical_instruments)

    @response_data = {
      'contents':ret,
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # 楽器検索 - ID検索
  # /api/v2/musical_instruments/:id
  #==========================
  def entry
    # musical_instrument.youtubesの返し方メモ
    #   - .order('published DESC') しないと順番通り返せない
    #   - musical_instrument.youtubes に対して事前にpage パラメータを付加した状態で返す
    #     - * これしないと最初の件数だけしか返せないよ...
    musical_instrument = MusicalInstrument.find( params[:id] )
    youtubes = musical_instrument.youtubes.order('published DESC').page(params[:page])
    @response_data = {
      'contents': {
        'musical_instrument' => musical_instrument,
        'youtubes'           => youtubes
      },
      'common': @common_data
    }
    resources_with_pagination(youtubes)
    render json: @response_data
  end
end
