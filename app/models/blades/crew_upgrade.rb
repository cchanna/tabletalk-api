class Blades::CrewUpgrade < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  belongs_to :crew

  def self.max name
    values = {
      "Boat" => 2,
      "Carriage" => 2,
      "Secure" => 2,
      "Vault" => 2,
    }
    return values[name] || 1
  end

  def self.cost name
    values = {
      "Steady" => 3,
      "Mastery" => 4
    }
    return values[name] || 1
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
        stress: true
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
      lair: {},
      quality: {},
      training: {},
      crew: {}
    }
    lair.each_with_index do |name, i|
      result[:lair][name] = {
        order: i,
        max: max(name),
        cost: cost(name),
        value: values[name] || 0
      }
    end
    quality.each_with_index do |name, i|
      result[:quality][name] = {
        order: i,
        max: max(name),
        cost: cost(name),
        value: values[name] ? 1 : 0
      }
    end
    training.each_with_index do |name, i|
      result[:training][name] = {
        order: i,
        max: max(name),
        cost: cost(name),
        value: values[name] ? 1 : 0
      }
    end
    crew = crew_upgrades[playbook] || []
    crew.each_with_index do |name, i|
      upgrade = definitions[name] || {}
      upgrade[:order] = i
      upgrade[:max] = max(name)
      upgrade[:cost] = cost(name)
      upgrade[:value] = values[name] ? 1 : 0
      result[:crew][name] = upgrade
    end
    return result
  end
end
