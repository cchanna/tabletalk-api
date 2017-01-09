class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  has_many :blades_character_permissions

  validates :name, presence: true, length: { maximum: 25}
  validates :admin, inclusion: { in: [true, false] }

  def load
    if Game.types[game.game_type] == :blades_in_the_dark
      return Blades.load id
    end
  end
end
