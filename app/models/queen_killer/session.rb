class QueenKiller::Session < ApplicationRecord
  belongs_to :game

  def characters
    return QueenKiller::Character.joins(:player).where(players: {game_id: game.id})
  end

  def self.start player
    return Result.failure if find_by(game: player.game)
    g = create game: player.game
    return Result.failure unless g.characters.count == g.game.players.count
    return Result.success(action: 'transition', data: 'intro')
  end

  def do action, data, player
    return Result.failure unless actions.include? action
    character = characters.find_by player: player
    return send action, data, character
  end

  def transition character
    result = nil;
    case phase
    when 'intro'
      result = 'name'
    when 'attractive'
      result = 'despise'
    when 'despise'
      return get_role character
    when 'role'
      result = 'play'
    end
    characters.update_all ready: false
    update phase: result
    return Result.success(action: 'transition', data: result)
  end

  def get_role character
    index = rand 0...characters.count
    characters[index].update killer: true
    index = rand 0...characters.count
    characters[index].update worthy: true
    update phase: 'role'
    characters.update_all ready: false
    return Result.success(action: 'get_role', data: 'role')
  end

  def actions
    return [:ready, :enter_name, :claim, :kiss, :cancel_kiss]
  end

  def ready data, character
    logger.info "READY #{data} #{character}"
    character.update ready: true
    return unless characters.where(ready: true).count == characters.count
    transition character
  end

  def enter_name data, character
    character.update name: data
    done = characters.where('queen_killer_characters.name IS NOT NULL').count == characters.count
    update phase: 'attractive' if done
    return Result.success(action: 'named', data: {name: data, id: character.id, phase: done ? 'attractive' : nil})
  end

  def claim data, character
    character.update dead: true unless character.worthy
    return Result.success(action: 'claimed', data: {id: character.id, worthy: character.worthy})
  end

  def kiss data, character
    love = characters.find_by id: data
    return Result.failure unless love
    kiss = QueenKiller::Kiss.find_by suitor_id: love.id, love: character
    if kiss
      return if kiss.accepted
      kiss.update accepted: true
      return Result.success(action: 'kissed', data: [character, love])
    end
    QueenKiller::Kiss.create suitor: character, love: love
    return nil
  end

  def cancel_kiss data, character
    kisses = character.kisses.where accepted: false
    kisses.destroy_all
    return nil
  end
end
