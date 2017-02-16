class Blades::CrewUpgrade < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  belongs_to :crew

  def to_json
    return name
  end
end
