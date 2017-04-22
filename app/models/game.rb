class Game < ApplicationRecord
  def self.types
    return [
      :world_of_adventure,
      :blades_in_the_dark,
      :queen_killer
    ]
  end

  has_many :players, dependent: :destroy
  has_many :users, through: :players
  validates :name, presence: true, length: { maximum: 25}
  validates :game_type, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: Game.types.length
  }

end
