class Api::V2::MusicalInstruments::PlayerController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # 演奏者検索 - トップ
  # /api/v2/musical_instruments/player
  #==========================
  def index
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

    @response_data = {
      'contents': _musical_instruments_player,
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # 演奏者検索 - 楽器ごと
  # /api/v2/musical_instruments/:musical_instrument_id/player
  #==========================
  def player_with_musical_instrument
    musical_instrument_id = params[:musical_instrument_id]
    member_ids_of_musical_instrument = MusicalInstrumentPlayer.where(
      :musical_instrument_id => musical_instrument_id
    ).select(:member_id).distinct

    players_info = get_player_info_of_musical_instrument(
      musical_instrument_id,
      member_ids_of_musical_instrument
    )

    @response_data = {
      'contents': {
        'musical_instrument': MusicalInstrument.find(musical_instrument_id),
        'players_info': players_info
      },
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # 演奏者検索 - 特定楽器の演奏者
  # /api/v2/musical_instruments/:musical_instrument_id/player/:member_id
  #==========================
  def player_with_member
    musical_instrument_id = params['musical_instrument_id']
    player_id = params['member_id']

    youtube_ids_of_player = MusicalInstrumentPlayer.where(
      "musical_instrument_id = ? AND member_id = ?", musical_instrument_id, player_id
    ).pluck('youtube_id')

    youtubes = Youtube.where(
      :id => youtube_ids_of_player
    ).order('published DESC').page(params[:page])
    resources_with_pagination(youtubes)

    @response_data = {
      'contents': {
        'musical_instrument': MusicalInstrument.find(musical_instrument_id),
        'player': Member.find(player_id),
        'youtubes': youtubes
      },
      'common': @common_data
    }
    render json: @response_data
  end
end
