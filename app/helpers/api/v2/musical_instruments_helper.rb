module Api::V2::MusicalInstrumentsHelper
  def get_player_info_of_musical_instrument(musical_instrument_id, player_ids)
    players_info = []
    player_ids.each do |player_id|
      musical_instrument_players = MusicalInstrumentPlayer.where(
        "musical_instrument_id = ? AND member_id = ?", musical_instrument_id, player_id.member_id
      )
      musical_instrument_player = musical_instrument_players.limit(1).order("RAND()")
      entry = Youtube.where( :id => musical_instrument_player.first.youtube_id ).first

      a_musical_insrument_player_info = {
          'player': Member.find(player_id.member_id),
          'youtube': entry,
      }

      players_info << a_musical_insrument_player_info
    end

    players_info
  end
end
