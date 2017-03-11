class Blades::VeteranCrewAbility < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  belongs_to :ability, class_name: :CrewAbility

  def to_json
    result = self.class.abilities[name]
    result = {} unless result
    result[:name] = name
    return result
  end
end
