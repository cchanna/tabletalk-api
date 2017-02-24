class Blades::Cohort < ApplicationRecord
  validates :name, :kind, length: { maximum: 50 }
  validates :kind, presence: true
  validates :weak, :impaired, :broken, :armor, inclusion: {
    in: [true, false]
  }

  belongs_to :crew

  def to_json
    quality = crew.tier
    quality += 1 unless is_gang
    return {
      id: id,
      name: name,
      kind: kind,
      isGang: is_gang,
      quality: quality,
      weak: weak,
      impaired: impaired,
      broken: broken,
      armor: armor,
      edges: edges,
      flaws: flaws,
      description: description
    }
  end
end
