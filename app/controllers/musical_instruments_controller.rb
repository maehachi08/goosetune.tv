class MusicalInstrumentsController < ApplicationController
  def index
    if ENV['API_MODE'] == 'false'
      _musical_instruments = []
      cache_name = "#{controller_name}_#{action_name}_musical_instruments_all"
      all_musical_instruments  = Rails.cache.fetch(cache_name) do
        MusicalInstrument.all
      end

      all_musical_instruments.each do |musical_instrument|
        data    = {}
        data['id']   = musical_instrument.id
        data['name'] = musical_instrument.name

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

      @data = ret
    else
      api_path = "/api/v2/musical_instruments"
      goosetune_api_get_data(params, api_path)
    end
  end

  def entry
    if ENV['API_MODE'] == 'false'
      musical_instrument = MusicalInstrument.find( params[:musical_instruments_id] )
      youtubes = musical_instrument.youtubes.order('published DESC').page(params[:page])

      @data = {
        'musical_instrument' => musical_instrument,
        'youtubes' => youtubes
      }
      @headers = {
        'x-next-page' => youtubes.next_page ? youtubes.next_page.to_s : ''
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      end
    else
      api_path = "/api/v2/musical_instruments/#{params[:musical_instruments_id]}"
      goosetune_api_get_paginate_data(params, api_path)
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
