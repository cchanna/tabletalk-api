module QueenKiller

  def self.table_name_prefix
    'queen_killer_'
  end

  def self.load as:
    data = {}
    player = as
    characters_data = Character.joins(:player).where(players: {game_id: player.game_id})
    characters = {}
    characters_data.each do |c|
      characters[c.id] = c.to_json player
    end
    game = QueenKiller::Session.find_by game_id: player.game_id
    character = characters_data.find_by(player: player)
    data = {
      characters: characters,
      phase: game && game.phase,
      started: game && game.started,
      ready: character && character.ready,
      mine: character && character.id,
      kiss: character && character.kiss && character.kiss.love_id
    }

    return Result.success data
  end
end
