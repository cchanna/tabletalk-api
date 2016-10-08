class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validates :name, presence: true, length: { maximum: 25}
  validates :admin, presence: true

end
