class MusicalInstruments::PlayerController < ApplicationController
  include Api::V2::MusicalInstrumentsHelper

  # 演奏者検索
  def index
    if ENV['API_MODE'] == 'false'
      _musical_instruments_player = {}
      musical_instrument_ids_of_players = MusicalInstrumentPlayer.all.pluck('musical_instrument_id').uniq

      musical_instrument_ids_of_players.each do |musical_instrument_id|
        musical_instrument = MusicalInstrument.find(musical_instrument_id)
        _musical_instruments_player[musical_instrument_id] = {}
        _musical_instruments_player[musical_instrument_id]['musical_instrument'] = musical_instrument

        member_ids_of_musical_instrument = MusicalInstrumentPlayer.where(
          :musical_instrument_id => musical_instrument_id
        ).select('member_id').distinct

        players_info = get_player_info_of_musical_instrument(
          musical_instrument_id,
          member_ids_of_musical_instrument
        )
        _musical_instruments_player[musical_instrument_id]['players'] = players_info
      end

      @data = _musical_instruments_player
      @common = {}
      @musical_instrument_ids = @data.keys
    else
      api_path = "/api/v2/musical_instruments/player"
      goosetune_api_get_data(params, api_path)
      @musical_instrument_ids = @data.keys
    end
  end

  # 演奏者検索: musical_instruments_name
  def list
    if ENV['API_MODE'] == 'false'
      musical_instrument_id = params[:musical_instruments_id]
      member_ids_of_musical_instrument = MusicalInstrumentPlayer.where(
        :musical_instrument_id => musical_instrument_id
      ).select(:member_id).distinct

      players_info = get_player_info_of_musical_instrument(
        musical_instrument_id,
        member_ids_of_musical_instrument
      )

      @data = {
        'musical_instrument': MusicalInstrument.find(musical_instrument_id),
        'players_info': players_info
      }
      @common = {}
    else
      api_path = "/api/v2/musical_instruments/#{params[:musical_instruments_id]}/player"
      goosetune_api_get_data(params, api_path)
    end
  end

  # 演奏者検索: musical_instruments_name(member_name)
  def entry
    if ENV['API_MODE'] == 'false'
      musical_instrument_id = params['musical_instruments_id']
      player_id = params['member_id']

      youtube_ids_of_player = MusicalInstrumentPlayer.where(
        "musical_instrument_id = ? AND member_id = ?", musical_instrument_id, player_id
      ).pluck('youtube_id')

      youtubes = Youtube.where(
        :id => youtube_ids_of_player
      ).order('published DESC').page(params[:page])

      @data = {
        'musical_instrument': MusicalInstrument.find(musical_instrument_id),
        'player': Member.find(player_id),
        'youtubes': youtubes
      }
      @common = {}
      @headers = {}
    else
      api_path = "/api/v2/musical_instruments/#{params[:musical_instruments_id]}/player/#{params['member_id']}"
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
