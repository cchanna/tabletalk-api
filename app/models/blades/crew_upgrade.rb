class Blades::CrewUpgrade < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  belongs_to :crew

  def self.max
    {
      "Boat" => 2,
      "Carriage" => 2,
      "Hidden" => 1,
      "Quarters" => 1,
      "Secure" => 2,
      "Vault" => 2,
      "Workshop" => 1,
    }
  end

  def self.cost
    {
      "Steady" => 3,
      "Mastery" => 4
    }
  end

  def self.lair
    ["Carriage", "Boat", "Hidden", "Quarters", "Secure", "Vault", "Workshop"]
  end

  def self.quality
    [
      "Documents", "Gear", "Implements", "Pet/Special",
      "Supplies", "Tools", "Weapons"
    ]
  end

  def self.training
    ["Insight", "Prowess", "Resolve", "Personal", "Mastery"]
  end

  def self.definitions
    {
      "Thief Rigging" => {
        rigging: ["tools", "gear"]
      },
      "Steady" => {
        stress: true,
      }
    }
  end

  def self.crew_upgrades
    {
      "Shadows" => [
        "Thief Rigging", "Underground Maps & Passkeys", "Elite Rooks",
        "Elite Skulks", "Steady"
      ]
    }
  end

  def self.map(upgrades, playbook)
    values = {}
    upgrades.each do |upgrade|
      unless values.has_key? upgrade.name
        values[upgrade.name] = 0
      end
      values[upgrade.name] += 1
    end
    puts upgrades.inspect
    result = {
      lair: [],
      quality: [],
      training: [],
      crew: []
    }
    lair.each do |name|
      result[:lair].push({
        name: name,
        max: max[name] || 1,
        value: values[name] || 0
      })
    end
    quality.each do |name|
      result[:quality].push({
        name: name,
        value: values[name] ? 1 : 0
      })
    end
    training.each do |name|
      result[:training].push({
        name: name,
        cost: cost[name] || 1,
        value: values[name] ? 1 : 0
      })
    end
    crew = crew_upgrades[playbook] || []
    crew.each do |name|
      upgrade = definitions[name] || {}
      upgrade[:name] = name
      upgrade[:cost] = cost[name] || 1
      upgrade[:value] = values[name] ? 1 : 0
      result[:crew].push upgrade
    end
    return result
  end
end
