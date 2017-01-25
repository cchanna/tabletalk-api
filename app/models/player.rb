class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validates :name, presence: true, length: { maximum: 25}
  validates :admin, inclusion: { in: [true, false] }

  def load
    if Game.types[game.game_type] == :blades_in_the_dark
      return Blades.load as: self
    end
    return Result.failure "nothing to load"
  end
end
