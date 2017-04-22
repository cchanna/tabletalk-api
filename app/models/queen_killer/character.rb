class QueenKiller::Character < ApplicationRecord
  belongs_to :player
  has_many :kisses, foreign_key: :suitor_id

  def kiss
    return kisses.find_by accepted: false
  end

  def self.join player
    return Result.failure if find_by player: player
    character = create player: player
    return Result.success(action: 'joined', data: character.to_json(player)) if character
    return Result.failure
  end

  def self.leave player
    character = find_by player: player
    return Result.failure unless character
    if character.destroy
      return Result.success(action: 'left', data: character.id)
    end
    return Result.failure
  end

  def to_json me
    result = {
      id: id,
      name: name,
      player: player_id,
      killer: nil,
      worthy: nil,
      dead: dead,
    }
    if me.id == player_id
      result[:killer] = killer
    end
    mine = QueenKiller::Character.find_by player: me
    if mine and (mine.kisses.find_by(love_id: id, accepted: true) or kisses.find_by(love_id: mine.id, accepted: true))
      result[:killer] = killer
      result[:worthy] = worthy
    end
    return result
  end
end
