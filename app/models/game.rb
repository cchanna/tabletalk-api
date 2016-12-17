class Game < ApplicationRecord
  def self.types
    return [
      'World of Adventure',
      'Blades in the Dark',
    ]
  end

  has_many :players
  has_many :users, through: :players
  validates :name, presence: true, length: { maximum: 25}
  validates :game_type, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: Game.types.length
  }

end
