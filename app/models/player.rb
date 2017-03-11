class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validates :name, presence: true, length: { maximum: 25}
  validates :admin, inclusion: { in: [true, false] }

  def load
    case Game.types[game.game_type]
    when :blades_in_the_dark
      return Blades.load as: self
    when :world_of_adventure
      return Adventure.load as: self
    end
    return Result.failure "nothing to load"
  end
end
