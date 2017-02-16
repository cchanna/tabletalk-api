class Blades::Cohort < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :quality, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :weak, :impaired, :broken, :armor, inclusion: {
    in: [true, false]
  }

  belongs_to :crew

  def to_json
    return {
      name: name,
      quality: quality,
      weak: weak,
      impaired: impaired,
      broken: broken,
      armor: armor,
      description: description
    }
  end
end
